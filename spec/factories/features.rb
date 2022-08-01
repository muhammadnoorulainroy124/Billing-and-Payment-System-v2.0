# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  factory :feature do
    name { Faker::Name.unique.name.gsub(/\W/, '')[0..19] }
    code { Faker::Alphanumeric.alphanumeric(6) }
    max_unit_limit { 10 }
    unit_price { 1000 }
  end
end
