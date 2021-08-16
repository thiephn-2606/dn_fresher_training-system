module CoursesHelper
  def status_select
    Course.statuses.keys
  end

  def subject_select
    Subject.select(:id, :name)
  end

  def user_select
    User.trainee.select(:id, :name)
  end

  def check_status_user_task user_course_subject
    user_course_subject.try(:user_tasks).pluck(:status).include?("in_progress")
  end

  def check_status_user_course_sb course_subject
    return if course_subject.blank?

    user_course =
      course_subject.user_course.find_by(user_id: current_user.id)
    return false if user_course.blank?

    user_course_sb =
      course_subject.user_course_subjects.find_by(
                                    course_subject_id: course_subject.id,
                                    user_course_id: user_course.id)
        return false if user_course_sb.blank?
    duration = course_subject.subject.try(:duration)
    time_start = user_course_sb.start_date
    time_end = user_course_sb.end_date
    time = Time.zone.now
    time_current = time.strftime("%d %B, %Y").to_date

    if user_course_sb.finished?
      status = (time_end - time_start > duration) ? "finished_beyond_time" : "finished"
    else
      status = (time_current - time_start > duration) ? "unfinished" : "in_progress"
    end
    content_tag(:span, t("helper.course.#{status}"))
  end

  def end_date_user_subject course_subject
    l(course_subject.start_date + course_subject.duration)
  end

  def user_course_subject course_subject
    user_course =
      course_subject.user_course.find_by(user_id: current_user.id)
    return false if user_course.blank?

    user_course_sb =
      course_subject.try(:user_course_subjects).find_by(
                          course_subject_id: course_subject.id,
                          user_course_id: user_course.id
                        )
  end

  def status_subject subject, course
    course_subject = subject.course_subjects.find_by(course_id: course.id)
    if course_subject.present?
      course_subject.status
    else
      content_tag(:span, t("helper.course.awaiting"))
    end
  end

  def status_subject_trainee_finished(user_course_subjects, course_subject)
    note_subject = user_course_subjects
                     .find_by(course_subject_id: course_subject.id)
    if note_subject.present?
      ( note_subject.end_date.to_date - note_subject.start_date.to_date > course_subject.duration ) ? "Finished beyond time" : "Finished"
    else
      content_tag(:span, t("helper.course.awaiting"))
    end
  end

  def start_date_end_date subject, course
    course_subject = subject.course_subjects.find_by(course_id: course.id).start_date
    if course_subject.present?
      content_tag(:span,
                  "#{l(course_subject)} -
                   #{l(course_subject + subject.duration)}(expected)")
    else
      content_tag(:span, t("helper.course.awaiting"))
    end
  end

  def start_date_end_date_finished subject, course
    course_subject = subject.course_subjects
                            .find_by(course_id: course.id)
    if course_subject.present?
      content_tag(:span,
                  "#{l(course_subject.start_date)} -
                   #{l(course_subject.end_date)}")
    else
      content_tag(:span, t("helper.course.awaiting"))
    end
  end

  def status_subject_trainee(user_course_subjects, course_subject)
    status_subject = user_course_subjects
                     .find_by(course_subject_id: course_subject.id)
    return status_subject.status if status_subject.present?
    
    content_tag(:span, t("helper.course.awaiting"))
  end
end
