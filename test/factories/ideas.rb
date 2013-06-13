FactoryGirl.define do
  factory :idea do
    user
    sequence(:title) { |n| "A kickass idea #{n}" }
    description "Something to describe my idea properly"
  end
end
