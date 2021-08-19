FactoryBot.define do
  factory :course_subject do
    status {1}
    association :course
    association :subject
  end
end
