FactoryBot.define do
  factory :user_course_subject do
    association :user_course
    association :course_subject
  end
end
