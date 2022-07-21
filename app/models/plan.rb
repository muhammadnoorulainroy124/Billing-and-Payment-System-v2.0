# frozen_string_literal: true

class Plan < ApplicationRecord
  attr_accessor :feature_ids

  has_many :feature_plans, dependent: :destroy
  has_many :features, through: :feature_plans

  has_many :subscriptions
  has_many :users, through: :subscriptions

  validates :name, :monthly_fee, presence: true
  validates :name, length: { minimum: 3, maximum: 20 }, name: true
  validates :name, uniqueness: true

  before_validation :create_monthly_charges, on: :create
  after_create :create_stripe_plan
  after_destroy :destroy_stripe_plan

  private

  def create_monthly_charges
    total = 0
      feature_ids.each do |index|
        next if index == ''

        price = Feature.where('id = ?', index.to_i).pluck(:unit_price)

        total += price.first
      end
      self.monthly_fee = total
  end

  def create_stripe_plan
    StripePlan.create(name: self.name, price_cents: self.monthly_fee * 100)
  end

  def destroy_stripe_plan
    StripePlan.find_by(name: self.name).destroy
  end
end
