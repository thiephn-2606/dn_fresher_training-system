require 'rails_helper'

RSpec.describe UserCourseSubject, type: :model do
  describe "associations" do
    it { should have_many(:user_tasks) }
    it { should have_many(:tasks) }
    it { should belong_to(:user_course) }
    it { should belong_to(:course_subject) }
  end

  describe "validations" do
    it { should define_enum_for(:status).with([:init, :in_progress, :finished]) }
  end
end
