class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses

  validates :name, presence: true, length: {maximum: Settings.name_maxlen}
  validates :email, presence: true, length: {maximum: Settings.email_maxlen},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.pass_minlen},
            allow_nil: true
  has_secure_password

  before_save :downcase_email
  enum roles: {trainee: 0, trainer: 1, admin: 2}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
