class Task < ApplicationRecord
  has_many :user_tasks, dependent: :destroy
  has_many :user_course_subjects, through: :user_tasks
end
