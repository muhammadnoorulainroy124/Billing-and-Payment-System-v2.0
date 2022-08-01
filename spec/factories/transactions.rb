# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  factory :transaction do
    plan_name { Faker::Name.name }
    amount { rand(2000...10_000) }
    buyer_name { Faker::Name.name }
    buyer_email { Faker::Internet.email }
  end
end
