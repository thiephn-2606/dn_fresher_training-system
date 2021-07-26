class User < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses
end
