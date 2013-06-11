# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :idea do
    user_id 1
    title "MyString"
    description "MyString"
  end
end
