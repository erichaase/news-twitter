require 'twitter'
require 'date'
require 'json'

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

    # Authenticate with Twitter
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    # Get list of followed users
    client.friends.each do |user|
      handle = user.screen_name

      # Process each user's posts
      client.user_timeline(handle, :count => 50).each do |post|
        attrs = {
          :source    => handle,
          :tid       => post.id,
          :published => DateTime.parse(post.created_at.to_s).utc,
          :updated   => DateTime.now.utc,
          :read      => nil,
          :clicked   => nil,
          :text      => post.text,
          :nfavorite => post.favorite_count,
          :nretweet  => post.retweet_count,
          :score     => (post.retweet_count + post.favorite_count) / 2,
          :json      => post.attrs.to_json,
        }

        # Update or create Post in database
        if post = Post.where(source: attrs[:source], tid: attrs[:tid]).take
          post.update_attributes(attrs)
        else
          Post.create(attrs)
        end
      end
    end
  end

end
