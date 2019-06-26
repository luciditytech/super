require 'bundler/setup'
require 'super'
require 'super/struct'

Bundler.require(:development)

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
