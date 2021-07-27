class Trainer::BaseController < ApplicationController
  layout "trainer/base"
  before_action :logged_in_user
  before_action :trainer_user
end
