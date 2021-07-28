class Course < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :subjects, through: :course_subjects
  has_many :course_subjects, dependent: :destroy
  enum status: {init: 0, in_progress: 1, finished: 2}

  scope :created_desc, ->{order(created_at: :desc)}
end
