# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeSubscription, type: :model do
  let(:stripe_subscription) { FactoryBot.create(:stripe_subscription) }

  describe 'associations' do
    context 'when stripe subscription created' do
      it { is_expected.to belong_to(:stripe_plan) }
      it { is_expected.to belong_to(:user) }
    end
  end
end
