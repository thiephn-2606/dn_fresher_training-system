class Trainee::UserCourseSubjectsController < Trainee::BaseController
  before_action :load_user_task, :check_status_user_task, only: :update

  def update
    begin
      @user_course_sb.finished!
      flash[:success] = t "controllers.user_course_subject_controller.success"
      redirect_to trainee_course_subject_path @user_course_sb.course_subject.id
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "controllers.user_course_subject_controller.faild"
      redirect_to trainee_course_subject_path @user_course_sb.course_subject.id
    end
  end

  private

  def load_user_task
    @user_course_sb = UserCourseSubject.find_by id: params[:id]
    return if @user_course_sb

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainee_courses_path
  end

  def check_status_user_task
    status_subject =
      @user_course_sb.user_tasks.pluck(:status).include?("in_progress")
    return unless status_subject

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainee_course_subject_path @user_course_sb.course_subject.id
  end
end
