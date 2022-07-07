# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :buyer_user
  belongs_to :plan

  validates :billing_day, presence: true
end
