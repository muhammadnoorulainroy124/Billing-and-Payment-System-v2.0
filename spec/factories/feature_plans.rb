# frozen_string_literal: true

FactoryBot.define do
  factory :feature_plans do
    feature_id { FactoryBot.create(:feature).id }
    plan_id { FactoryBot.create(:plan).id }
  end
end
