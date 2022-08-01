# frozen_string_literal: true

def plan_data
  FactoryBot.create(:plan)
end

FactoryBot.define do
  factory :stripe_plan do
    name { "#{plan_data.name}_#{rand(1...999)}" }
    price_cents { plan_data.monthly_fee * 100 }
    interval { 'month' }
  end
end
