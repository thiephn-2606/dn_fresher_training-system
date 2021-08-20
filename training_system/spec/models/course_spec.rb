require 'rails_helper'

RSpec.describe Course, type: :model do
 
  let!(:course1) {FactoryBot.create(:course)}
  let!(:course2) {FactoryBot.create(:course)}
  let!(:course3) {FactoryBot.create(:course, name: "thiep")}
  let!(:course_date) {FactoryBot.build(:course, start_date: "2021-07-05 10:00:00", end_date: "2021-02-05 09:00:00")}

  describe "associations" do
    it { should have_many(:user_courses) }
    it { should have_many(:users) }
    it { should have_many(:course_subjects) }
    it { should have_many(:subjects) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

    context "when start date greater current date" do
      it "should not be valid if start date greater current date" do
        course_date.should_not be_valid
      end
    
      it "raises an error if start date greater current date" do
        course_date.valid?
        course_date.errors.full_messages.should include(
          I18n.t("courses.mess_start_date_error"),
          I18n.t("courses.mess_start_date_eq_end_date_error")
        )
      end
  
      it "should be valid if end date is after start date" do
        course_date.should_not be_valid
      end
    
      it "raises an error if end date is after start date" do
        course_date.valid?
        course_date.errors.full_messages.should include(I18n.t("courses.mess_start_date_eq_end_date_error"))
      end
    end

    describe "scope" do
      it "search by name like 'thiep' " do
        expect(Course.search("thiep")).to eq([course3])
      end
    end
  end
end
