FactoryGirl.define do
  factory :user do
    provider "facebook"
    sequence(:uid) { |n| n }
    name "Dario Barrionuevo"
    sequence(:email) { |n| "email#{n}@insignia4u.com" }
    oauth_token "009090909"
    oauth_expires_at "2014-06-12 16:57:31"
  end
end
