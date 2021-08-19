FactoryBot.define do
  factory :user_task do
    status {1}
    association :user_course_subject
    association :task
  end
end
