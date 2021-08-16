class Trainee::UserCourseSubjectsController < Trainee::BaseController
  before_action :load_user_course,
                :load_user_course_subject,
                :check_status_user_task,
                :load_course_sb,
                only: [:update, :start_subject]

  def update
    begin
      @user_course_subject.finished!
      @user_course_subject.update!(end_date: Time.zone.now.to_date)
      flash[:success] = t "controllers.user_course_subject_controller.success"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "controllers.user_course_subject_controller.faild"
    ensure
      redirect_to trainee_course_course_subject_path @course_sb, @user_course.course.id
    end
  end

  def start_subject
    ActiveRecord::Base.transaction do
      @user_course_subject.in_progress!
      @user_course_subject.update!(start_date: Time.zone.now.to_date)
      @user_course_subject.course_subject.subject.tasks.each do |user_task|
        @user_course_subject.user_tasks.build(task_id: user_task.id).save!
      end
      flash[:success] = t "controllers.user_course_subject_controller.success"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "controllers.course_controller.assign_trainee.f"
    ensure
      redirect_to trainee_course_course_subject_path @course_sb, @user_course.course.id
    end
  end

  private

  def load_user_course_subject
    @user_course_subject = @user_course.user_course_subjects.find_by id: params[:id]
    return if @user_course_subject

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainee_courses_path
  end

  def check_status_user_task
    status_subject =
      @user_course_subject.user_tasks.pluck(:status).include?("in_progress")
    return unless status_subject

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainee_course_course_subject_path @course_sb
  end

  def load_user_course
    @user_course = @current_user.user_courses.find_by course_id: params[:course_id]
    return if @user_course

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainee_courses_path
  end

  def load_course_sb
   @course_sb = @user_course_subject.course_subject_id
  end
end
