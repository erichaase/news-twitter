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
    feeds = Post.select(:source).uniq.map { |p| p.source }

    feeds.each do |handle|
      # calculate retweet percentiles
      prt = {}
      posts = Post.where(source: handle).order(:nretweet)
      count = 0
      posts.each do |p|
        prt[p.tid] = (count / (posts.size - 1.0)) * 100
        count += 1
      end

      # calculate favorite percentiles
      pf = {}
      posts = Post.where(source: handle).order(:nfavorite)
      count = 0
      posts.each do |p|
        pf[p.tid] = (count / (posts.size - 1.0)) * 100
        count += 1
      end

      # store score (average of percentiles)
      Post.where(source: handle).each do |p|
        score = (prt[p.tid] + pf[p.tid]) / 2
        p.update_attributes(score: score.to_i)
      end
    end
  end

end
