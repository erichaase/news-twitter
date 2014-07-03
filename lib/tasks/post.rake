require 'twitter'
require 'date'
require 'json'

def authenticate
  Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end
end

namespace :post do

  desc "Print Posts"
  task :print => :environment do
    Post.order(:score).each { |p| puts p }
  end

  desc "Delete Posts"
  task :delete => :environment do
    Post.delete_all
  end

  desc "Collect and store Posts"
  task :collect => :environment do
    client = authenticate

    client.friends.each do |user|
      handle = user.screen_name

      client.user_timeline(handle, :count => 50).each do |post|
        attrs = {
          :source    => handle,
          :tid       => post.id,
          :published => DateTime.parse(post.created_at.to_s).utc,
          :updated   => DateTime.now.utc,
          :read      => nil,
          :clicked   => nil,
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
    client = authenticate

    client.friends.each do |user|
      handle = user.screen_name

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
