class StripePlan < ApplicationRecord
  has_many :stripe_subscriptions, dependent: :destroy

  validates :name, :stripe_price_id, :price_cents, presence: true
  validates :name, :stripe_price_id, uniqueness: true

  enum interval: %i[month]

  before_validation :create_stripe_reference, on: :create
  before_destroy :delete_stripe_plan

  def create_stripe_reference
    response = Stripe::Price.create({
      unit_amount: price_cents,
      currency: 'usd',
      recurring: { interval: 'month' },
      product_data: { name: name }
    })
    self.stripe_price_id = response.id
  end

  def retrieve_stripe_reference
    Stripe::Price.retrieve(stripe_price_id)
  end

  def delete_stripe_plan
    puts"\n\n\n\n\n\n\n\n\n\n#{"update stripe"}\n\n\n\n\n\n\n\n\n\n"
    Stripe::Plan.delete(
      self.stripe_price_id
    )
  end

end
