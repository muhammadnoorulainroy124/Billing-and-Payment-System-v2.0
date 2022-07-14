class StripeSubscription < ApplicationRecord
  attr_accessor :card_number, :exp_month, :exp_year, :cvc

  belongs_to :stripe_plan
  belongs_to :user

  validates :stripe_id, presence: true, uniqueness: true

  before_validation :create_stripe_reference, on: :create

  def create_stripe_reference
    puts "#{card_number} + #{exp_month} + #{exp_year} + #{cvc}"
    Stripe::Customer.create_source(
      user.stripe_id,
      { source: generate_card_token }
    )
    response = Stripe::Subscription.create({
      customer: user.stripe_id,
      items: [
        { price: stripe_plan.stripe_price_id }
      ]
    })
    self.stripe_id = response.id
  end

  def generate_card_token
    Stripe::Token.create({
      card: {
        number: card_number,
        exp_month: exp_month,
        exp_year: exp_year,
        cvc: cvc
      }
    }).id
  end

end
