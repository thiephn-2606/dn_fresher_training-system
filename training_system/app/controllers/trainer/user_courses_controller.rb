class Trainer::UserCoursesController < ApplicationController
  before_action :load_course, only: :create
  before_action :load_course_destroy, only: :destroy

  def new; end

  def edit; end

  def create
    if params[:user_ids].present?
      assign_trainee
    else
      flash[:danger] = t "controllers.course_controller.assign_trainee.f"
      redirect_to edit_trainer_course_path @course.id
    end
  end

  def destroy
    remove_trainee
  end

  private

  def load_course
    @course = Course.find_by id: params[:course_id]
    return if @course

    flash[:danger] = t "controllers.course_controller.error_show"
    redirect_to edit_trainer_course_path @course.id
  end

  def load_course_destroy
    @course_destroy = Course.find_by id: params[:id]
    return if @course_destroy

    flash[:danger] = t "controllers.course_controller.error_show"
    redirect_to edit_trainer_course_path @course.id
  end

  def assign_trainee
    @course.transaction do
      params[:user_ids].each do |user|
        @course.user_courses.build user_id: user
      end
      @course.save!
      flash[:success] = t "controllers.course_controller.assign_trainee.suc"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "controllers.course_controller.assign_trainee.f"
    ensure
      redirect_to edit_trainer_course_path @course.id
    end
  end

  def remove_trainee
    trainees = User.user_in_course params[:user_ids]
    if @course_destroy.present? && trainees.present?
      trainees_destroy = @course_destroy.user_courses
                                        .user_course_in_course(trainees.ids)
      @course_destroy.transaction do
        trainees_destroy.destroy_all
        flash[:success] = t "controllers.course_controller.remove_trainee.suc"
      rescue ActiveRecord::RecordInvalid
        flash[:danger] = t "controllers.course_controller.remove_trainee.fail"
      ensure
        redirect_to edit_trainer_course_path @course_destroy.id
      end
    else
      flash[:danger] = t "controllers.course_controller.remove_trainee.fail"
      redirect_to edit_trainer_course_path @course_destroy.id
    end
  end
end
