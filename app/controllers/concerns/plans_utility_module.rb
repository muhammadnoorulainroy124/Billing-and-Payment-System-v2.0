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
end
