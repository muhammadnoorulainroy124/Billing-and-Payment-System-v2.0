# frozen_string_literal: true

class Plan < ApplicationRecord
  attr_accessor :features
  has_many :feature_plans, dependent: :destroy
  has_many :features, through: :feature_plans

  has_many :subscriptions
  has_many :users, through: :subscriptions

  validates :name, :monthly_fee, presence: true
  validates :name, length: { minimum: 3, maximum: 20 }, name: true
  validates :name, uniqueness: true

  before_create :calculate_monthly_charges

  def calculate_monthly_charges
    total = 0
    feature_ids.each do |index|
      next if index == ''

      price = Feature.where('id = ?', index.to_i).pluck(:unit_price)

      total += price.first
    end
    total
  end
end
