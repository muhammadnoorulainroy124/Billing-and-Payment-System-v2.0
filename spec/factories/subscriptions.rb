# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    buyer_id { FactoryBot.create(:buyer).id }
    plan_id { FactoryBot.create(:plan).id }
    billing_day { Time.zone.today }
  end
end
