FactoryBot.define do
  factory :exam do
    sequence(:id) { |n| n }
    exam_id { SecureRandom.uuid }
    sequence(:name) { |n| "Exam #{n}" }
    started_at { Time.current }
    ended_at { Time.current + 1.hours }
    status { Exam::Status::ACTIVATED }
    # other attributes...
  end
end