# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

unless Exam.any?
  Exam.create!(exam_id: "9b432092-47b2-4e80-8fc6-ae00950185d8", name: "첫 번째 시험", started_at: Time.current + 7.days, ended_at:  Time.current + 7.days + 1.hours)
  Exam.create!(exam_id: "28d7b6ff-1aba-4310-8f41-0ae4412f0abc", name: "두 번째 시험", started_at: Time.current + 1.days, ended_at:  Time.current + 1.days + 1.hours)
  Exam.create!(exam_id: "31j186fz-1ab2-4310-8f41-1126nash5n13", name: "이미 끝난 시험", started_at: Time.current - 5.days, ended_at:  Time.current - 5.days + 1.hours)
end

unless User.any?
  User.create!(email: "abcd@gmail.com", password: "password!", user_id: "7e84a38f-9747-4895-8e01-67e711556437", role: User::Role::ADMIN)
  User.create!(email: "haaland@naver.com", password: "password!", user_id: "94136473-4fcb-44ee-ab21-247611571f83", role: User::Role::CUSTOMER)
end