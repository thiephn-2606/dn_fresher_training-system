module CoursesHelper
  def status_select
    Course.statuses.keys
  end
end
