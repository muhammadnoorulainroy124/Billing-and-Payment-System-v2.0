# frozen_string_literal: true

module PlansUtilityModule
  extend ActiveSupport::Concern

  def self.calculate_monthly_charges(feature_ids)
    total = 0
    feature_ids.each do |index|
      next if index == ''

      price = Feature.where('id = ?', index.to_i).pluck(:unit_price)

      total += price.first
    end
    total
  end

  def self.update_stripe_plan(plan)
    s_plan = StripePlan.find_by(name: plan.name)
    plans_plan.retrieve_stripe_reference_id
    Stripe::Plan.update(
      'price_1LMi78BHZ29CJnGhcszDJUZI',
      {metadata: {order_id: '6735'}},
    )
  end
end
