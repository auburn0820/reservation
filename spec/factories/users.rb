FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { 'password' }
    # other attributes...
  end
end