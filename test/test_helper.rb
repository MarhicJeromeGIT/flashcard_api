ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods
  
  def clear_redis
    # Only clear the keys that belong to our namespace
    namespace = $redis.namespace
    keys = $redis.redis.keys.select { |key| key.starts_with? namespace }
    keys.each do |key|
      $redis.redis.del key
    end
  end
end
