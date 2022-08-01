# frozen_string_literal: true

class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :create_stripe_reference, on: %i[create update]

  PASSWORD_FORMAT = /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x.freeze
  EMAIL_REGEX_PATTERN = /\A[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$\z/.freeze

  PASS_FORMAT_MSG = 'Password must contain at least 8 charachters, 1 digit, 1 lowercase, 1 uppercase, and a symbol'

  validates :name, length: { minimum: 3, maximum: 20 }
  validates :name, format: { with: /\A[^0-9`!@#$%\^&*+_=]+\z/ }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: EMAIL_REGEX_PATTERN }
  validates :password,
            length: { in: Devise.password_length },
            format: { with: PASSWORD_FORMAT, message: PASS_FORMAT_MSG },
            confirmation: true

  has_one_attached :image

  def create_stripe_reference
    return unless email_valid?(email)

    response = StripeServices::CustomerCreator.call(email)
    self.stripe_id = response.id
  end

  def retrieve_stripe_reference
    StripeServices::CustomerRetriever.call(stripe_id)
  end

  def email_valid?(email)
    email =~ EMAIL_REGEX_PATTERN
  end
end
