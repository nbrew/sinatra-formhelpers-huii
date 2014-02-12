require 'rack/test'
require 'simplecov'
require 'sinatra/base'

# Coverage tool, needs to be started as soon as possible
SimpleCov.start do
  add_filter '/spec/' # Ignore spec directory
end

require 'sinatra/form_helpers'

class TestFormHelpers
  include Sinatra::FormHelpers
  attr_accessor :params
  def initialize
    @params = {}
  end
end
def fh
  @fh ||= TestFormHelpers.new
end

class Application < Sinatra::Base
  helpers Sinatra::FormHelpers
  set :raise_errors, false
  set :show_exceptions, false
end

module RSpecMixin
  include Rack::Test::Methods

  def app
    Application
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
end
