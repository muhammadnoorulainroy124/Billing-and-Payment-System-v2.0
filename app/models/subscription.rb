class Subscription < ApplicationRecord
  belongs_to :buyer
  belongs_to :plan

  validates :billing_day, presence: true
end
