ENV['RACK_ENV'] = 'test'
require_relative '../config/environment'
require_relative '../app'

require 'rack/test'
require 'rspec'

module RspecMixin
  include Rack::Test::Methods
  def app() App end
end

RSpec.configure do |conf|
  conf.include RspecMixin
end
require 'support/database_cleaner'