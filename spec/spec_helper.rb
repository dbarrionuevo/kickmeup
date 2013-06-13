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

def load_facebook_auth_data(valid = true)
  user              = FactoryGirl.build(:user)

  auth              = Hashie::Mash.new
  auth.provider     = user.provider
  auth.uid          = user.uid
  auth.info         = { email: valid ? user.email : "", name: "Dario Barrionuevo" }
  auth.credentials  = { token: "0909090909", expires_at: 1346878866 }

  OmniAuth.config.mock_auth[:facebook] = auth
  auth
end

def current_user
  OmniAuth.config.mock_auth[:facebook]
end
