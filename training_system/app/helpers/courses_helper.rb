module CoursesHelper
  def subject_select
    Subject.select(:id, :name)
  end

  def user_select
    User.select(:id, :name)
  end
end
