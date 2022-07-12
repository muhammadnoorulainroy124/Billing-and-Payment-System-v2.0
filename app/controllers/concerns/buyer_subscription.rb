# frozen_string_literal: true

module BuyerSubscription
  extend ActiveSupport::Concern

  def self.stripe_plan_id(plan_id)
    plan_name = Plan.find(plan_id).name
    StripePlan.find_by(name: plan_name).id
  end
end
