class Trainer::CoursesController < Trainer::BaseController
  def index
    @courses = Course.created_desc.page(params[:page])
                     .per(Settings.courses.per_page)
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:success] = t "courses.create.success"
      redirect_to trainer_courses_path
    else
      render :new
    end
  end

  private

  def course_params
    params.require(:course).permit(
      :name, :description, :status, :start_date, :end_date
    )
  end
end
