FactoryBot.define do
  factory :user_course do
    status {1}
    association :course
    association :subject
  end
end
