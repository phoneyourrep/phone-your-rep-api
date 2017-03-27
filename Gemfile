# frozen_string_literal: true
source 'https://rubygems.org'
ruby '2.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'activerecord-postgis-adapter', '~> 4.0', '>= 4.0.2'
gem 'bugsnag', '~> 5.1.0'
gem 'devise'
gem 'dragonfly', '~> 1.1.1'
gem 'faker', '~> 1.6', '>= 1.6.6'
gem 'figaro'
gem 'get_your_rep', '~> 1.0', '>= 1.0.8'
gem 'impressionist', '~> 1.5.0', '>= 1.5.2'
gem 'jbuilder'
gem 'multi_json'
gem 'nokogiri', '1.6.8.1'
gem 'pg', '~> 0.19.0'
gem 'puma', '~> 3.0'
gem 'rack-attack', '~> 5.0.0', '>= 5.0.1'
gem 'rack-cors', '~> 0.4.0'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'responders'
gem 'rgeo-shapefile', '~> 0.4'
gem 'rqrcode', '~> 0.10.1'
gem 'simple_token_authentication', '~> 1.0'
gem 'vpim', '~> 13.11', '>= 13.11.11'
gem 'yajl-ruby'

group :development, :test do
  gem 'database_cleaner'
  gem 'pry', '~> 0.10.4'
  gem 'pry-byebug'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'rack-cache', require: 'rack/cache'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
