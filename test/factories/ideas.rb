FactoryGirl.define do
  factory :idea do
    user
    sequence(:title) { |n| "A kickass idea #{n}" }
    description "Something to describe my idea properly"

    trait :with_kickups do
      after(:create) do |instance|
        create_list :idea_kickup, 1, idea: instance, user: instance.user
      end
    end
  end
end
