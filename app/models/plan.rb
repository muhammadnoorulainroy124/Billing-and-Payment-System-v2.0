# frozen_string_literal: true

class Plan < ApplicationRecord
  attr_accessor :feature_ids

  has_many :feature_plans, dependent: :destroy
  has_many :features, through: :feature_plans

  has_many :subscriptions, dependent: nil
  has_many :buyers, through: :subscriptions

  validates :name, :monthly_fee, presence: true
  validates :monthly_fee, numericality: { greater_than: 0, less_than: 100_000_000 }
  validates :name, length: { minimum: 3, maximum: 20 }
  validates :name, format: { with: /\A[a-zA-Z0-9\s]+\z/i, message: 'can only contain letters and numbers.' }
  validates :name, uniqueness: { case_sensitive: false }

  before_validation :create_monthly_charges, on: :create
  after_create :create_stripe_plan, :create_feature_plan
  after_destroy :destroy_stripe_plan

  def create_monthly_charges
    return if feature_ids.nil?

    total = 0
    feature_ids.each do |index|
      next if index == ''

      price = Feature.where('id = ?', index.to_i).pluck(:unit_price)

      total += price.first
    end
    self.monthly_fee = total
  end

  def create_stripe_plan
    StripePlan.create(name: name, price_cents: monthly_fee * 100)
  end

  def destroy_stripe_plan
    StripePlan.find_by(name: name).destroy
  end

  def create_feature_plan
    feature_ids&.each do |f_id|
      next if f_id == ''

      FeaturePlan.create(plan_id: id, feature_id: f_id)
    end
  end
end
