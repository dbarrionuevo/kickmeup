require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

OmniAuth.config.test_mode = true

RSpec.configure do |config|

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    ActionMailer::Base.deliveries.clear
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.infer_base_class_for_anonymous_controllers = true
  config.include Rails.application.routes.url_helpers

end

def load_facebook_auth_data( valid = true )
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123456',
      info: { email: valid ? 'jdoe@kickmeup.com' : '' }
      })
end

def current_user
  #load_facebook_auth_data
  OmniAuth.config.mock_auth[:facebook]
end