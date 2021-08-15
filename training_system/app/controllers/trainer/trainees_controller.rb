class Trainer::TraineesController < Trainer::BaseController
  before_action :load_trainee, :load_user_course_subjects, :load_course, only: :show

  def show
    @course_subjects = @course.course_subjects
                              .page(params[:page])
                              .per(Settings.courses.per_page)
    load_user_course_subjects
  end

  private

  def load_trainee
    @trainee = User.find_by id: params[:id]
    return if @trainee

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainer_course_path
  end

  def load_user_course_subjects
    user_course = @trainee.user_courses.find_by(course_id: params[:course_id])
    return (@user_course_subjects = user_course.user_course_subjects) if user_course

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainer_course_path
  end

  def load_course
    @course = @trainee.courses.find_by(id: params[:course_id])
    return if @course

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainer_course_path
  end
end
