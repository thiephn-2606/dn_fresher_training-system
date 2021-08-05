class Trainee::BaseController < ApplicationController
  layout "trainee/base"
  before_action :logged_in_user
  before_action :is_trainee
end
