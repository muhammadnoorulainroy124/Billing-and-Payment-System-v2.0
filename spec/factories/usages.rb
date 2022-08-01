# frozen_string_literal: true

def f_id(subscription_id)
  plan_id = Subscription.find(subscription_id).plan_id
  plan = Plan.find(plan_id)
  plan.features.pluck(:id).first
end

FactoryBot.define do
  factory :usage do
    subscription_id { FactoryBot.create(:subscription).id }
    feature_id { f_id(subscription_id) }
  end
end
