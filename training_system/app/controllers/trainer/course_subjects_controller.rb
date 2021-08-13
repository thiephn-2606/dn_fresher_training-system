class Trainer::CourseSubjectsController < Trainer::BaseController
  before_action :load_subject, :check_all_finished, only: :update

  def update
    @course_subject.transaction do
      @course_subject.finished!
      @course_subject.update! end_date: Time.zone.now.to_date
      flash[:success] = t("controllers.course_subjects_controller.success")
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t("controllers.course_subjects_controller.fail")
    ensure
      redirect_to trainer_course_path @course.id
    end
  end

  private

  def load_subject
    load_course
    @course_subject = @course.course_subjects
                             .find_by subject_id: params[:subject_id]
    return if @course_subject

    flash[:danger] = t("controllers.course_subjects_controller.error_show")
    redirect_to trainee_courses_path
  end

  def load_course
    @course = Course.find_by id: params[:course_id]
    return if @course

    flash[:danger] = t("controllers.course_subjects_controller.error_show")
    redirect_to trainee_courses_path
  end

  def status_check course_subject, status
    course_subject.user_course_subjects
                  .pluck(:status).include?(status)
  end

  def check_all_finished
    if status_check(@course_subject, "in_progress") || status_check(@course_subject, "init")
      flash[:danger] = t("controllers.course_subjects_controller.fail")
      redirect_to trainer_course_path @course.id
    end
  end
end
