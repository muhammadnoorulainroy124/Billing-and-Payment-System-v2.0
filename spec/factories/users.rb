# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  factory :user do
    name { Faker::Name.name.gsub(/\W/, '') }
    email { Faker::Internet.email }
    password { 'Noorulain2@' }
    stripe_id { Faker::Lorem.unique.word }

    trait :admin do
      type { 'Admin' }
    end

    trait :buyer do
      type { 'Buyer' }
    end

    factory :admin, traits: [:admin]
    factory :buyer, traits: [:buyer]
  end
end
