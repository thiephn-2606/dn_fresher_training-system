class Course < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :subjects, through: :course_subjects
  has_many :course_subjects, dependent: :destroy
end
