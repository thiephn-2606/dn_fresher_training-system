module CoursesHelper
  def user_select
    User.select(:id, :name)
  end

  def courses_select
    User.select(:id, :name)
  end
end
