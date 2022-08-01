# frozen_string_literal: true

class StripeSubscription < ApplicationRecord
  attr_accessor :card_number, :exp_month, :exp_year, :cvc

  belongs_to :stripe_plan
  belongs_to :user

  validates :stripe_id, presence: true, uniqueness: true
end
