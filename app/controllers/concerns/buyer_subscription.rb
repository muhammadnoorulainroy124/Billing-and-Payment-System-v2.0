# frozen_string_literal: true

module BuyerSubscription
  extend ActiveSupport::Concern

  def self.stripe_plan_id(plan_id)
    plan_name = Plan.find(plan_id).name
    StripePlan.find_by(name: plan_name).id
  end

  def self.subscription_features_usage(plan_id, buyer_id)
    subscription = Subscription.find_by(buyer_id: buyer_id, plan_id: plan_id)
    feature_ids = Plan.find(plan_id).features.pluck(:id)
    return feature_ids, subscription.id
  end

  def insert_features_usage(subscription_data)
    feature_ids = subscription_data.first
    feature_ids.each do |f_id|
      Usage.create(subscription_id: subscription_data.last, feature_id: f_id)
    end
  end
end
