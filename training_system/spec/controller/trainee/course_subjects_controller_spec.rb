require "rails_helper"
include SessionsHelper

RSpec.describe Trainee::CourseSubjectsController, type: :controller do
  let!(:user) { FactoryBot.create :user, roles: 0 }
  let!(:course) { FactoryBot.create :course }
  let!(:subject) { FactoryBot.create :subject }
  let!(:user_course) { FactoryBot.create :user_course, user_id: user.id, course_id: course.id }
  let!(:course_subject) { FactoryBot.create :course_subject, subject_id: subject.id, course_id: course.id }
  let!(:user_course_subject) { FactoryBot.create :user_course_subject, user_course_id: user_course.id, course_subject_id: course_subject.id }

  describe "GET #show" do

    context "when user is loggin" do
      before do
        log_in user
        get :show, params: { id: course_subject.id, course_id: course.id }
      end

      it "renders the #show view" do
        expect(response).to render_template :show
      end
    end

    context "when user is invalid not course subject" do
      before do
        log_in user
        get :show, params: { id: -10, course_id: course.id }
      end

      it "flash dagger" do
        expect(flash[:danger]).to eq I18n.t("controllers.course_controller.error_show")
      end

      it "renders the #show view" do
        expect(response).to redirect_to trainee_courses_path
      end
    end
  end
end
