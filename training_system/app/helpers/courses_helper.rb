module CoursesHelper
  def status_select
    Course.statuses.keys
  end

  def subject_select
    Subject.select(:id, :name)
  end

  def user_select
    User.select(:id, :name)
  end

  def status_subject subject, course
    course_subject = subject.course_subjects.find_by(course_id: course.id)
    if course_subject.present?
      course_subject.status
    else
      content_tag(:span, t("helper.course.awaiting"))
    end
  end
end
