class Trainer::CoursesController < Trainer::BaseController
  def index
    @courses = Course.created_desc.page(params[:page])
                     .per(Settings.courses.per_page)
  end
end
