require 'rails_helper'

RSpec.describe CourseSubject, type: :model do
  let!(:course) {FactoryBot.create(:course)}
  let!(:course_subject1) {FactoryBot.create(:course_subject, course_id: course.id)}
  let!(:course_subject2) {FactoryBot.create(:course_subject, course_id: course.id)}

  describe "associations" do
    it { should have_many(:user_course_subjects) }
    it { should have_many(:course_subjects) }
    it { should have_many(:user_course) }
    it { should belong_to(:subject) }
    it { should belong_to(:course) }
  end
end
