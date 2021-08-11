class Trainee::CourseSubjectsController < Trainee::BaseController
  before_action :load_subject,
                :load_user_course,
                :load_user_course_subject,
                only: [:show]

  def show; end

  private

  def load_subject
    @course_subject = CourseSubject.find_by id: params[:id]
    return if @course_subject

    flash[:danger] = t("controllers.course_subjects_controller.error_show")
    redirect_to trainee_courses_path
  end

  def load_user_course_subject
    @user_course_subject =
      @course_subject.user_course_subjects.find_by(
        user_course_id: @user_course.id,
        course_subject_id: @course_subject.id
      )
    return if @user_course_subject

    flash[:danger] = t("controllers.course_subjects_controller.error_show")
    redirect_to trainee_courses_path
  end

  def load_user_course
    @user_course = @course_subject.user_course.find_by(user_id: current_user.id)
    return if @user_course

    flash[:danger] = t("controllers.course_subjects_controller.error_show")
    redirect_to trainee_courses_path
  end
end
