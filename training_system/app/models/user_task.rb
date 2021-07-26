class UserTask < ApplicationRecord
  belongs_to :user_course_subject
  belongs_to :task
end
