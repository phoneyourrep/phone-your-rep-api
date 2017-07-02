# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'activerecord-postgis-adapter', '~> 4.0', '>= 4.0.2'
gem 'bugsnag', '~> 5.1.0'
gem 'devise', '~> 4.2.0'
gem 'dragonfly', '~> 1.1.1'
gem 'faker', '~> 1.6', '>= 1.6.6'
gem 'faraday', '~> 0.11.0'
gem 'figaro', '~> 1.1.0', '>= 1.1.1'
gem 'geocoder', '~> 1.4.0', '>= 1.4.1'
gem 'governator', '>= 0.1.13'
gem 'has_scope', '~> 0.7.1'
gem 'impressionist', '~> 1.6.0'
gem 'jbuilder', '~> 2.4.0', '>= 2.4.1'
gem 'lapi', git: 'https://github.com/msimonborg/lapi'
gem 'multi_json', '~> 1.12.0', '>= 1.12.1'
gem 'naught', '~> 1.1.0'
gem 'nokogiri', '~> 1.8.0'
gem 'pg', '~> 0.19.0'
gem 'puma', '~> 3.0'
gem 'rack-attack', '~> 5.0.0', '>= 5.0.1'
gem 'rack-cors', '~> 0.4.0'
gem 'rails', '~> 5.0.0', '>= 5.0.3'
gem 'responders', '~> 2.3.0'
gem 'rgeo-shapefile', '~> 0.4.2'
gem 'rqrcode', '~> 0.10.1'
gem 'simple_token_authentication', '~> 1.0'
gem 'vpim', '~> 13.11', '>= 13.11.11'
gem 'yajl-ruby', '~> 1.3.0'

group :development, :test do
  gem 'coveralls', '~> 0.8.0', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'pry', '~> 0.10.4'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.5.0'
  gem 'rubocop', '~> 0.48.0', '>= 0.48.1'
  gem 'simplecov', '~> 0.14.0', require: false
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'rack-cache', '~> 1.6.0', '>= 1.6.1', require: 'rack/cache'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
