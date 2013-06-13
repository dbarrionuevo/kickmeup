# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    provider "facebook"
    uid "123456"
    name "Dario Barrionuevo"
    email "dario@insignia4u.com"
    oauth_token "009090909"
    oauth_expires_at "2014-06-12 16:57:31"
  end
end
