# frozen_string_literal: true

module BuyerSubscription
  extend ActiveSupport::Concern

  # def self.stripe_plan_id(plan_id)
  #   plan_name = Plan.find(plan_id).name
  #   StripePlan.find_by(name: plan_name).id
  # end

  def self.subscription_features_usage(plan_id, buyer_id)
    subscription = Subscription.find_by(buyer_id: buyer_id, plan_id: plan_id)
    feature_ids = Plan.find(plan_id).features.pluck(:id)
    [feature_ids, subscription.id]
  end

  def insert_features_usage(subscription_data)
    feature_ids = subscription_data.first
    feature_ids.each do |f_id|
      Usage.create(subscription_id: subscription_data.last, feature_id: f_id)
    end
  end

  # def self.update_usage(subscription, params)
  #   params[:subscription].each do |key, value|
  #     Usage.where(subscription_id: subscription.id, feature_id: key).update(usage: value)
  #   end
  # end

  # def self.verify_usage_limit(params)
  #   usage_limit = {}
  #   plan = Plan.find(params[:id])
  #   f_ids = plan.features.pluck(:id)
  #   f_ids.each do |f_id|
  #     usage_limit[f_id] = Feature.find(f_id).max_unit_limit
  #   end
  #   overcharge = calculate_price(params, usage_limit)
  #   update_stripe_plan(plan, overcharge) if overcharge.positive?
  # end

  # def self.calculate_price(params, usage_limit)
  #   overcharge = 0
  #   params[:subscription].each do |key, value|
  #     if value.to_i > usage_limit[key.to_i]
  #       exceeded_units = value.to_i - usage_limit[key.to_i]
  #       overcharge += exceeded_units * Feature.find(key.to_i).unit_price
  #     end
  #   end
  #   overcharge
  # end

  # def self.update_stripe_plan(plan, overcharge)
  #   stripe_plan = StripePlan.new(name: "#{plan.name} extended_#{rand(1..1000)}",
  #                                price_cents: (plan.monthly_fee + overcharge) * 100)
  #   stripe_plan.save

  #   s_plan = StripePlan.find_by(name: plan.name)
  #   s_subscription = StripeSubscription.find_by(stripe_plan_id: s_plan.id)
  #   s_subscription.update_subscription(stripe_plan.stripe_price_id, s_subscription.stripe_id)
  # end
end
