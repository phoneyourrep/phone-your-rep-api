# frozen_string_literal: true

Governator.config do |config|
  config.use_twitter = true

  config.twitter do |twitter|
    twitter.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
    twitter.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
    twitter.access_token        = ENV['TWITTER_ACCESS_TOKEN']
    twitter.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end
end
