module BuyerSubscription

  extend ActiveSupport::Concern
  require 'Date'

  def self.insert_in_subscription_table(plan_ids)
    begin
      plan_ids.each do |p_id|
        next if p_id == ""

        Subscription.create(buyer_id: current_user.id, plan_id: p_id, billing_day: Date.today)
      end
      return true
    rescue
      return false
    end
  end
end
