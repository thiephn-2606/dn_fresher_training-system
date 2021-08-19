require 'rails_helper'
include SessionsHelper

RSpec.describe Trainer::CourseSubjectsController, type: :controller do
  let!(:user) {FactoryBot.create :user, roles: "trainer"}
  let!(:course) {FactoryBot.create :course}
  let!(:subject) {FactoryBot.create :subject}
  let!(:course_subject) {course.course_subjects.create(subject_id: subject.id) }

  describe "PUT course_subject#update" do
    context "valid attributes" do
      before do
        log_in user
        put :update, params: {
            id: course_subject.id,
            course_id: course.id,
            subject_id: subject.id,
            end_date: Time.zone.now.to_date
          }
      end

      it "assign @course_subject " do
        expect(assigns(:course_subject)).not_to be_nil
      end
   
      it "redirects to the trainer course_subject path" do
        expect(response).to redirect_to trainer_course_path course.id 
      end
    end
  end
end
