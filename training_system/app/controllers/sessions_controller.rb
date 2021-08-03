class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.authenticate(params[:session][:password])
      flash[:success] = t "session.success"
      log_in @user
      switch_layout
    else
      flash.now[:danger] = t "session.account_invalid"
      render :new
    end
  end

  def switch_layout
    if current_user.trainer?
      redirect_to trainer_courses_path
    else
      redirect_to trainee_courses_path
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user

    flash.now[:danger] = t "session.not_account"
    render :new
  end
end
