require 'twitter'
require 'date'
require 'json'

namespace :posts do

  desc "Print Posts"
  task :print, [:source] => :environment do |t, args|
    args.with_defaults(:source => "all")

    case args.source
    when 'all'
      puts Post.all.to_a.sort
    else
      puts Post.where(source: args.source).to_a.sort
    end
  end

  desc "Collect and store Posts"
  task :collect => :environment do
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    # TODO: error out if authentication failed

    client.friends.each do |user|
      handle = user.screen_name

      client.user_timeline(handle, :count => 100).each do |post|
        attrs = {
          :source    => handle,
          :tid       => post.id,
          :published => DateTime.parse(post.created_at.to_s).utc,
          :updated   => DateTime.now.utc,
          :text      => post.text.gsub(/\s+/, " "),
          :nfavorite => post.favorite_count,
          :nretweet  => post.retweet_count,
          :json      => post.attrs.to_json,
        }

        if post = Post.where(source: attrs[:source], tid: attrs[:tid]).take
          post.update_attributes(attrs)
        else
          attrs[:score] = 0
          Post.create(attrs)
        end
      end
    end
  end

  desc "Score Posts"
  task :score => :environment do
    # to calculate percentiles, only examine posts 'ndays' days ago
    if ndays = ENV['NEWS_SCORE_NDAYS']
      ndays = ndays.to_i
    else
      ndays = 14
    end

    feeds = Post.select(:source).uniq.map { |p| p.source }
    feeds.each do |handle|
      # get posts for the past 'ndays' days
      posts = Post.where("source = ? AND published > ?", handle, DateTime.now.utc - ndays.day)

      # calculate retweet percentiles
      prt = {}
      count = 0
      posts.order(:nretweet).each do |p|
        prt[p.tid] = (count / (posts.size - 1.0)) * 100
        count += 1
      end

      # calculate favorite percentiles
      pf = {}
      count = 0
      posts.order(:nfavorite).each do |p|
        pf[p.tid] = (count / (posts.size - 1.0)) * 100
        count += 1
      end

      # store score (average of percentiles)
      posts.each do |p|
        score = (prt[p.tid] + pf[p.tid]) / 2
        p.update_attributes(score: score.to_i)
      end
    end
  end

end
