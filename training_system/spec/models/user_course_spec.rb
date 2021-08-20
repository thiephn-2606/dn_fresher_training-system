require 'rails_helper'

RSpec.describe UserCourse, type: :model do
  let!(:user) {FactoryBot.create(:user)}

  describe "associations" do
    it { should have_many(:user_course_subjects) }
    it { should have_many(:course_subjects) }
    it { should belong_to(:course) }
    it { should belong_to(:user) }
  end
end
