class UserCourseSubject < ApplicationRecord
  belongs_to :user_course
  belongs_to :course_subject
end
