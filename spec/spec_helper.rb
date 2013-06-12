require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  
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
  config.include Features::SessionHelpers, type: :feature
  config.include Features::IdeaHelpers, type: :feature
  config.order = "random"
end

def load_facebook_auth_data( valid = true )
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    provider: 'facebook',
    uid: valid ? '123456' : nil,
    info: { email: valid ? 'jdoe@kickmeup.com' : nil },
    invalid: true
    })
end

def current_user
  OmniAuth.config.mock_auth[:facebook]
end