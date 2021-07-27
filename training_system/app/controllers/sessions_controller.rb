class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to login_path
    else
      flash.now[:danger] = t "session.account_invalid"
      render :new
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
