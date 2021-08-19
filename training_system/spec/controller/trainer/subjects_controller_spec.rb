require 'rails_helper'
include SessionsHelper

RSpec.describe Trainer::SubjectsController, type: :controller do
  let!(:user) {FactoryBot.create :user, roles: "trainer"}
  let!(:course) {FactoryBot.create :course}
  let!(:subject) {FactoryBot.create :subject}
  let!(:course_subject) {course.course_subjects.create(subject_id: subject.id) }

  describe "POST subject#create" do
    context "success when valid attributes" do
      before do
        log_in user
        get :create, params: {
          subject: {
            name: "ruby",
            description: "test",
            duration: 5,
            tasks_attributes: [FactoryBot.build(:task).attributes, FactoryBot.build(:task).attributes],
          }
        }
      end

      it "assign @subject " do
        expect(assigns(:subject)).not_to be_nil
      end

      it "success when create" do
        expect(flash[:success]).to eq I18n.t("controllers.subject_controller.create.success")
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end
    end

    context "fail when invalid attributes" do
      before do
        log_in user
        get :create, params: {
          subject: {
            name: "ruby",
            description: "",
            duration: 5,
            tasks_attributes: [:name, :description, :duration],
          }
        }
      end

      it "errors when create vaild attribuste " do
        expect(flash[:danger]).to eq  I18n.t("controllers.subject_controller.create.faild")
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end
    end
  end
end
