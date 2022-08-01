# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    context 'when validating transaction' do
      it { is_expected.to validate_presence_of(:plan_name) }
      it { is_expected.to validate_presence_of(:amount) }
      it { is_expected.to validate_presence_of(:buyer_name) }
      it { is_expected.to validate_presence_of(:buyer_email) }
    end
  end

  describe 'scope' do
    context 'when most recent transactions requested' do
      it 'must return transactions ordered by created_at' do
        expect(described_class.all.most_recent_transactions_first).to eq(described_class.all.order('created_at DESC'))
      end
    end
  end
end
