class Trainee::UserTasksController < Trainee::BaseController
  before_action :load_user_course,
                :load_user_course_subject,
                :load_user_task,
                :load_course_subject, only: :update

  def update
    begin
      @user_task.finished!
      flash[:success] = t "controllers.user_tasks_controller.success"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "controllers.user_tasks_controller.faild"
    ensure
      redirect_to trainee_course_course_subject_path @course_subject.id, @user_course.course.id
    end
  end

  private

  def load_user_task
    @user_task = @user_course_subject.user_tasks.find_by id: params[:id]
    return if @user_task

    flash[:danger] = t("controllers.user_tasks_controller.error_show")
    redirect_to trainee_courses_path
  end

  def load_course_subject
    @course_subject = @user_task.user_course_subject.try(:course_subject)
  end

  def load_user_course
    @user_course = @current_user.user_courses.find_by course_id: params[:course_id]
    return if @user_course

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainee_courses_path
  end

  def load_user_course_subject
    @user_course_subject =
      @user_course.user_course_subjects.find_by id: params[:user_course_subject_id]
    return if @user_course_subject

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainee_courses_path
  end
  
end
