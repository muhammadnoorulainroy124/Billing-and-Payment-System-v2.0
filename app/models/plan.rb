# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :feature_plans, dependent: :destroy
  has_many :features, through: :feature_plans

  has_many :subscriptions
  has_many :users, through: :subscriptions

  validates :name, :monthly_fee, presence: true
  validates :name, length: { minimum: 3, maximum: 20 }
  validates :name, uniqueness: true
  validates :terms_of_service, acceptance: true
end
