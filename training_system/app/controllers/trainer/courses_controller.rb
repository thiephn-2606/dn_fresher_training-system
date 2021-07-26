class Trainer::CoursesController < Trainer::BaseController
  before_action :load_course, only: :show
  before_action :params_user_course, only: :create

  def index
    @courses = Course.created_desc.page(params[:page])
                     .per(Settings.courses.per_page)
  end

  def show
    load_trainers @course
    load_trainees @course
    load_subjects @course
  end

  def new
    @course = Course.new
    @course.user_courses.build
  end

  def create
    if @course.save
      @user_id.each do |user_course|
        @course.user_courses.build(user_id: @user_id[@startcount]).save
      end
      flash[:success] = t "courses.create.success"
      redirect_to trainer_courses_path
    else
      render :new
    end
  end

  private

  def course_params
    params.require(:course).permit(
      :name, :description, :status, :start_date, :end_date,
      user_courses_attributes: [user_id: []]
    )
  end

  def load_course
    @course = Course.find_by id: params[:id]
    return if @course

    flash[:danger] = t("controllers.course_controller.error_show")
    redirect_to trainer_courses_path
  end

  def load_trainers course
    @trainers = course.users.trainer.page(params[:page])
                      .per(Settings.courses.per_page)
  end

  def load_trainees course
    @trainees = course.users.trainee.page(params[:page])
                      .per(Settings.courses.per_page)
  end

  def load_subjects course
    @subjects = course.subjects.page(params[:page])
                      .per(Settings.courses.per_page)
  end

  def params_user_course
    @course = Course.new course_params
    @startcount = 1
    @user_id = params[:course][:user_courses_attributes]["0"][:user_id]
    @course.user_courses.each do |m|
      m.user_id = @user_id[@startcount]
      @startcount += 1
    end
  end
end
