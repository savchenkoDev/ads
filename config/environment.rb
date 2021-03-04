require 'bundler/setup'
require "sinatra"
require 'sinatra/activerecord'
require 'require_all'
require "rubygems"
require "bundler"

APP_ENV = ENV["RACK_ENV"] || "development"

Bundler.require :default, APP_ENV.to_sym
Bundler.require Sinatra::Base.environment

require "active_support/deprecation"
require "active_support/all"

require_rel '../app/**/*.rb'
autoload_rel '../app/**/*.rb'
