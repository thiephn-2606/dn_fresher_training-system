class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def trainer_user
    redirect_to(log_in_path) unless current_user.trainer?
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("controllers.course_controller.let_login")
    redirect_to login_path
  end
end
