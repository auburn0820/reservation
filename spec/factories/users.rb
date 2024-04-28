FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:id) { |n| n }
    user_id { "c842a23b-9bbc-472f-84fd-ead4457762ea" }
    password { "password" }
    # other attributes...
  end
end