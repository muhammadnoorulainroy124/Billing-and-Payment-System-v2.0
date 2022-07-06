# frozen_string_literal: true

module BuyerSubscription
  extend ActiveSupport::Concern
  require 'Date'

  def self.insert_in_subscription_table(plan_ids)
    plan_ids.each do |p_id|
      next if p_id == ''

      Subscription.create(buyer_id: current_user.id, plan_id: p_id, billing_day: Time.zone.today)
    end
    true
  rescue StandardError
    false
  end
end
