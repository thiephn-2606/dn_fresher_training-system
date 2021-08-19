require 'rails_helper'
include SessionsHelper

RSpec.describe Trainee::CourseSubjectsController, type: :controller do
  let!(:user) {FactoryBot.create(:user, roles: "trainee")}
  let!(:user_course_subject) {FactoryBot.create(:user_course_subject)}

  describe "GET course_subject#show" do
    context "when user is loggin" do
      before do
        log_in user
        get :show, params: { id: user_course_subject.id }
      end

      it "assigns the @course" do
        expect(assigns(:course_subject)).to eq(course_subject)
      end

      it "renders the #show view" do
        expect(response).to render_template :show
      end
    end
  end
end
