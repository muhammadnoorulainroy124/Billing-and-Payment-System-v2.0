class Transaction < ApplicationRecord
  validates :plan_name, :amount, :buyer_name, :buyer_email, presence: true
end
