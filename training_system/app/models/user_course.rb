class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course
  has_many :user_course_subjects, dependent: :destroy
  has_many :course_subjects, through: :user_course_subjects

  scope :user_course_in_course, ->(id){where(user_id: id)}
end
