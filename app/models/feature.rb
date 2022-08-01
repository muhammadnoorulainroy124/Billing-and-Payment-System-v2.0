# frozen_string_literal: true

class Feature < ApplicationRecord
  has_many :feature_plans, dependent: nil
  has_many :plans, through: :feature_plans

  validates :name, :code, :max_unit_limit, :unit_price, presence: true
  validates :name, :code, uniqueness: { case_sensitive: false }
  validates :code, length: { minimum: 3, maximum: 6 }
  validates :name, length: { minimum: 3, maximum: 20 }
  validates :name, format: { with: /\A[a-zA-Z0-9\s]+\z/i, message: 'can only contain letters and numbers.' }
  validates :unit_price, numericality: { greater_than: 0, less_than: 100_000 }
  validates :max_unit_limit, numericality: { greater_than: 0, less_than: 10_000 }
end
