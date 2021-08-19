require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  let!(:user) { FactoryBot.create(:user, roles: 1) }
  let!(:user1) { FactoryBot.create(:user, roles: 0) }


  describe "POST sessions#create" do
    context "with valid" do
      it "redirects the trainer courses path" do
        get :create, 
          params: { 
            session: {
              email: user.email,
              password: user.password 
            }
          }
        expect(response).to redirect_to trainer_courses_path
        expect(flash[:success]).to eq I18n.t("session.success")
      end

      it "redirects the trainee courses path" do
        get :create, 
          params: {
            session: {
              email: user1.email,
              password: user1.password
            }
          }
        expect(response).to redirect_to trainee_courses_path
        expect(flash[:success]).to eq I18n.t("session.success")
      end
    end

    context "with invalid" do
      it "does not redirect the trainer courses path" do
        get :create,
          params: { session: { email: user.email, password: "abcdef" } }
        expect(response).to_not redirect_to trainer_courses_path
        expect(flash[:danger]).to eq I18n.t("session.account_invalid")
      end
    end

    context "session not account" do
      it "does not redirect the trainer courses path" do
        get :create, 
          params: { session: { email: "", password: "" } }
          expect(flash[:danger]).to eq I18n.t("session.not_account")
          expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE sessions#destroy' do
    before :each do
      get :destroy,
      params: { session: { user_id: user.id } }
    end
    
    it "when destroys user session" do
      session[:user_id].should be_nil
    end

    it "redirects login page" do
      expect(response).to redirect_to login_path
    end
  end
end
