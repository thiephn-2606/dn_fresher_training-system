class Subject < ApplicationRecord
  has_many :courses, through: :course_subjects
  has_many :course_subjects, dependent: :destroy
end
