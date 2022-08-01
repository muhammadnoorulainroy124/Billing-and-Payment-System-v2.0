# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plan, type: :model do
  let(:plan) { FactoryBot.create(:plan) }

  describe 'associations' do
    context 'when plan created' do
      it { is_expected.to have_many(:feature_plans).dependent(:destroy) }
      it { is_expected.to have_many(:features).through(:feature_plans) }

      it { is_expected.to have_many(:subscriptions) }
      it { is_expected.to have_many(:buyers).through(:subscriptions) }
    end
  end

  describe 'callbacks' do
    context 'with plan' do
      it { is_expected.to callback(:create_monthly_charges).before(:validation).on(:create) }
      it { is_expected.to callback(:create_stripe_plan).after(:create) }
      it { is_expected.to callback(:create_feature_plan).after(:create) }
      it { is_expected.to callback(:destroy_stripe_plan).after(:destroy) }
    end
  end

  describe 'DB constraint' do
    context 'when plan table created' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_index(:name) }
    end
  end

  describe 'validation' do
    context 'when validating plan' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:monthly_fee) }
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
      it { is_expected.to validate_numericality_of(:monthly_fee).is_greater_than(0).is_less_than(100_000_000) }
      it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(20) }
    end
  end

  describe 'monthly fee validation' do
    context 'when creating plan' do
      it 'must calculate plan monthly fee' do
        plan.create_monthly_charges
        expect(plan.monthly_fee).to be > 0
      end
    end
  end

  describe 'stripe plan' do
    context 'when deleting plan' do
      it 'must delete stripe plan' do
        plan.destroy_stripe_plan
        expect(StripePlan.find_by(name: plan.name)).to be nil
      end
    end
  end

  describe 'name validation' do
    context 'with special characters' do
      it 'must raise ActiveRecord::RecordInvalid for "ab@c"' do
        expect { plan.update!(name: 'ab@c') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'must raise ActiveRecord::RecordInvalid for "abc!"' do
        expect { plan.update!(name: 'abc!') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'must raise ActiveRecord::RecordInvalid for "abc&*$"' do
        expect { plan.update!(name: 'abc&*$') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'must must raise ActiveRecord::RecordInvalid for "abc~<>()"' do
        expect { plan.update!(name: 'abc~<>()') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'without special characters' do
      it 'must update successfully' do
        expect(plan.update(name: 'abcdefghj32')).to eq(true)
      end
    end
  end

  describe 'unit price validation' do
    context 'with string price' do
      it 'must raise ActiveRecord::RecordInvalid for "abcd"' do
        expect { plan.update!(monthly_fee: 'abcd') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'must raise ActiveRecord::RecordInvalid for "123abc"' do
        expect { plan.update!(monthly_fee: '123abc') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'must raise ActiveRecord::RecordInvalid for "123@#$"' do
        expect { plan.update!(monthly_fee: '123@#$') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with integer price' do
      it 'must update successfully' do
        expect(plan.update(monthly_fee: 4300)).to eq(true)
      end
    end
  end
end
