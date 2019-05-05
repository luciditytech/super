ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
ENV['APPLICATION_ROOT'] ||= File.expand_path('../', __dir__)

require 'bundler/setup'
require 'dotenv/load'

Bundler.require

require_relative '../app/application'

Application.boot
