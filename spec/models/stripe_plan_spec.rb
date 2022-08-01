# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripePlan, type: :model do
  let(:stripe_plan) { FactoryBot.create(:stripe_plan) }

  describe 'associations' do
    context 'when stripe plan created' do
      it { is_expected.to have_many(:stripe_subscriptions).dependent(:destroy) }
    end
  end

  describe 'validations' do
    context 'when validating stripe plan' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:price_cents) }
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    end
  end

  describe 'callbacks' do
    context 'with stripe plan' do
      it { is_expected.to callback(:create_stripe_reference).before(:validation).on(:create) }
      it { is_expected.to callback(:delete_stripe_plan).before(:destroy) }
    end
  end

  describe 'stripe reference' do
    context 'when retrieve' do
      it 'must return stripe reference' do
        expect(stripe_plan.retrieve_stripe_reference).not_to be_nil
      end
    end
  end
end
