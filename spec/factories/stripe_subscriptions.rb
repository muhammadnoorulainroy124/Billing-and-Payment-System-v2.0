# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_subscription do
    user_id { FactoryBot.create(:buyer).id }
    stripe_plan_id { FactoryBot.create(:subscription).stripe_plan_id }
    active { true }
  end
end
