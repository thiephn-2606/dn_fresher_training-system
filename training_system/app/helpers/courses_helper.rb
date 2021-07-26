module CoursesHelper
  def user_select
    @subject = User.all
  end
end
