# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'activerecord-postgis-adapter', '~> 4.0', '>= 4.0.2'
gem 'bugsnag', '~> 5.1.0'
gem 'devise', '~> 4.2.0'
gem 'dragonfly', '~> 1.1.1'
gem 'faker', '~> 1.6', '>= 1.6.6'
gem 'figaro', '~> 1.1.0', '>= 1.1.1'
gem 'geocoder', '~> 1.4.0', '>= 1.4.1'
gem 'has_scope', '0.7.0'
gem 'impressionist', '~> 1.5.0', '>= 1.5.2'
gem 'jbuilder', '~> 2.4.0', '>= 2.4.1'
gem 'multi_json', '~> 1.12.0', '>= 1.12.1'
gem 'nokogiri', '1.6.8.1'
gem 'pg', '~> 0.19.0'
gem 'puma', '~> 3.0'
gem 'rack-attack', '~> 5.0.0', '>= 5.0.1'
gem 'rack-cors', '~> 0.4.0'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'responders', '~> 2.3.0'
gem 'rgeo-shapefile', '0.4.2'
gem 'rqrcode', '~> 0.10.1'
gem 'simple_token_authentication', '~> 1.0'
gem 'vpim', '~> 13.11', '>= 13.11.11'
gem 'yajl-ruby', '~> 1.3.0'

group :development, :test do
  gem 'database_cleaner'
  gem 'pry', '~> 0.10.4'
  gem 'pry-byebug'
  gem 'rubocop', '~> 0.48.0', '>= 0.48.1'
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
