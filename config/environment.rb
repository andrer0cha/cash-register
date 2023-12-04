# frozen_string_literal: true

require 'sinatra'
require 'bundler'
require 'bundler/setup'
require 'sinatra-initializers'
require 'sinatra/activerecord'

LOGGER = Logger.new($stdout)

APP_ENV = ENV['RACK_ENV'] || 'development'
Bundler.require :default, APP_ENV.to_sym

require_all 'app/**/*.rb'

register Sinatra::Initializers
register Sinatra::ActiveRecordExtension
