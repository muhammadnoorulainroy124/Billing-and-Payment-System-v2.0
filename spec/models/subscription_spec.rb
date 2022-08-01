# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { FactoryBot.create(:subscription) }

  describe 'associations' do
    context 'when created' do
      it { is_expected.to belong_to(:buyer) }
      it { is_expected.to belong_to(:plan) }
    end
  end

  describe 'callbacks' do
    context 'when subscription created' do
      it { is_expected.to callback(:create_usage).after(:create) }
      it { is_expected.to callback(:destroy_subscription_data).before(:destroy) }
    end
  end

  describe 'validations' do
    context 'when validaing subscription' do
      it { is_expected.to validate_presence_of(:billing_day) }
    end
  end

  describe 'usage' do
    context 'when subscription created' do
      it 'must create usage of associated features' do
        expect(Usage.where(subscription_id: subscription.id).count).to be > 0
      end
    end

    context 'when usage updated' do
      it 'must update usage in Usage table' do
        usage = FactoryBot.create(:usage)
        subscrption = described_class.find(usage.subscription_id)
        feature_id = Usage.find(usage.id).feature_id
        data = { subscription: { "#{feature_id}": 1000 } }
        subscrption.update_usage(data)
        expect(Usage.find(usage.id).usage).to eq(1000)
      end
    end
  end

  describe 'overcharge' do
    context 'when usage increased' do
      it 'must verify usage limit' do
        data = { subscription: Usage.where(subscription_id: subscription.id).pluck(:feature_id) }
        subscription.verify_usage_limit(data)
      end

      it 'must overcharge if usage limit exceeded' do
        usage = FactoryBot.create(:usage)
        subscrption = described_class.find(usage.subscription_id)
        feature_id = Usage.find(usage.id).feature_id
        data = { subscription: { "#{feature_id}": 20 } }
        subscrption.update_usage(data)
        expect(subscrption.verify_usage_limit(data)).to eq(0.1e5)
      end
    end
  end

  describe 'stripe plan id' do
    context 'when retrieving' do
      it 'must return stripe plan id' do
        expect(subscription.stripe_plan_id).not_to be_nil
      end
    end
  end

  describe 'destroy subscription' do
    context 'when subscription deleted' do
      it 'must delete its associated data' do
        expect(subscription.destroy).to eq(true)
      end
    end
  end
end
