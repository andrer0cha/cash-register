# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo|  "https://github.com/#{repo}.git" }

ruby '~> 3.2.2'

gem "dry-initializer", "~> 3.1"
gem "puma", '~> 6.4' # Use Puma as the app server
gem "require_all", '~> 3.0'
gem "sinatra", "~> 3.1"
gem "sinatra-initializers", "~> 0.1"
gem "sinatra-activerecord", "~> 2.0"
gem "sqlite3", "~> 1.6", force_ruby_platform: true
gem "rake", "~> 13.0"

group :development do
  gem 'rack-cors', '~> 2.0'
end

group :test do
  gem 'rspec', '~>3.12'
  gem 'rack-test', '~> 2.1'
end

group :development, :test do
  gem 'pry-byebug', '~> 3.10'
  gem 'rubocop', '~> 1.57', require: false
  gem 'rubocop-rspec', '~> 2.25', require: false
  gem 'shoulda-matchers', '~> 5.0'
end
