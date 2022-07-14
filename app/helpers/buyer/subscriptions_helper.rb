# frozen_string_literal: true

module Buyer::SubscriptionsHelper
  @is_plan_available = false

  def not_subscribed_plans
    buyer_plans = current_user.plans
    not_subscribed = Plan.left_joins(:subscriptions).where.not(id: buyer_plans)
    @is_plan_available = true if not_subscribed.length.positive?
    not_subscribed
  end

  def all_plans
    Plan.all
  end

  def all_features_of_plan(plan)
    plan.features
  end

  def available?
    @is_plan_available
  end

  def subscription_features(subscription)
    plan = Plan.find(subscription.plan_id)
    plan.features
  end

  def subscription_feature_usage(subscription, feature)
    puts "subscription id is #{subscription.id}"
    subscription_feature = Usage.find_by(subscription_id: subscription.id, feature_id: feature.id)
    subscription_feature.usage
  end
end

