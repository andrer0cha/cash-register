# frozen_string_literal: true

require 'bundler'
require 'bundler/setup'
require 'sinatra-initializers'
require 'sinatra/activerecord'



APP_ENV = ENV['RACK_ENV'] || 'development'
Bundler.require :default, APP_ENV.to_sym

#require_relative "environments/#{APP_ENV}"
require_all 'app/**/*.rb'

register Sinatra::Initializers

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database, { adapter: "sqlite3", database: 'cash_register.sqlite3'}

  use ApplicationController
end
