# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :buyer
  belongs_to :plan

  validates :billing_day, presence: true

  after_create :create_usage
  before_destroy :destroy_subscription_data

  def stripe_plan_id
    plan_name = Plan.find(plan_id).name
    StripePlan.find_by(name: plan_name).id
  end

  def verify_usage_limit(data)
    usage_limit = {}
    f_ids = Plan.find(plan_id).features.pluck(:id)
    f_ids.each do |f_id|
      usage_limit[f_id] = Feature.find(f_id).max_unit_limit
    end
    overcharge = calculate_overcharge(usage_limit, data)
  end

  def update_usage(data)
    data[:subscription].each do |key, value|
      Usage.where(subscription_id: id, feature_id: key.to_s.to_i).update(usage: value)
    end
  end

  private

  def create_usage
    subscription_data = subscription_features_usage
    insert_features_usage(subscription_data)
  end

  def insert_features_usage(subscription_data)
    feature_ids = subscription_data.first
    feature_ids.each do |f_id|
      Usage.create(subscription_id: subscription_data.last, feature_id: f_id)
    end
  end

  def subscription_features_usage
    subs = Subscription.find_by(buyer_id: buyer_id, plan_id: plan_id)
    feature_ids = Plan.find(plan_id).features.pluck(:id)
    [feature_ids, subs.id]
  end

  def calculate_overcharge(usage_limit, data)
    overcharge = 0
    data[:subscription].each do |key, value|
      if value.to_i > usage_limit[key.to_s.to_i]
        exceeded_units = value.to_i - usage_limit[key.to_s.to_i]
        overcharge += exceeded_units * Feature.find(key.to_s.to_i).unit_price
      end
    end
    overcharge
  end

  def destroy_subscription_data
    plan = Plan.find(plan_id)
    stripe_plan = StripePlan.find_by(name: plan.name)
    StripeSubscription.find_by(stripe_plan_id: stripe_plan.id).update(active: false)
  end
end
