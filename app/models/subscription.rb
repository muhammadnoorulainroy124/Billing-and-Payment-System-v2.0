# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :buyer
  belongs_to :plan

  validates :billing_day, presence: true

  def stripe_plan_id
    StripePlan.find_by(name: plan.name).id
  end
end
