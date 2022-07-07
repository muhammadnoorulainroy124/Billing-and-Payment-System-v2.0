# frozen_string_literal: true

class Feature < ApplicationRecord
  has_many :feature_plans, dependent: :destroy
  has_many :plans, through: :feature_plans

  validates :name, :code, :usage, :max_unit_limit, :unit_price, presence: true
  validates :name, :code, uniqueness: true
  validates :terms_of_service, acceptance: true
end
