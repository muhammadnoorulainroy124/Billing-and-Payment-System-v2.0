# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  factory :plan do
    name { Faker::Name.unique.name.gsub(/\W/, '') }
    feature_ids do
      [
        FactoryBot.create(:feature).id,
        FactoryBot.create(:feature).id,
        FactoryBot.create(:feature).id
      ]
    end
  end
end
