# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feature, type: :model do
  let(:feature) { FactoryBot.create(:feature) }

  describe 'associations' do
    context 'with feature association' do
      it { is_expected.to have_many(:feature_plans).dependent(nil) }
      it { is_expected.to have_many(:plans).through(:feature_plans) }
    end
  end

  describe 'DB constraints' do
    context 'when feature table created' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:code).of_type(:string) }
      it { is_expected.to have_db_index(:code) }
      it { is_expected.to have_db_index(:name) }
    end
  end

  describe 'validation' do
    context 'when validating feature' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:code) }
      it { is_expected.to validate_presence_of(:unit_price) }
      it { is_expected.to validate_presence_of(:max_unit_limit) }
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
      it { is_expected.to validate_numericality_of(:unit_price).is_greater_than(0).is_less_than(100_000) }
      it { is_expected.to validate_numericality_of(:max_unit_limit).is_greater_than(0).is_less_than(10_000) }
      it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(20) }
      it { is_expected.to validate_length_of(:code).is_at_least(3).is_at_most(6) }
    end
  end

  describe 'name validation' do
    context 'with special characters' do
      it '"ab@c" must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(name: 'ab@c') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"abc!" must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(name: 'abc!') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"abc&*$" must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(name: 'abc&*$') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"abc~<>()" must must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(name: 'abc~<>()') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'without special characters' do
      it 'must update successfully' do
        expect(feature.update(name: 'abcdefghj32')).to eq(true)
      end
    end
  end

  describe 'unit price validation' do
    context 'with string price' do
      it '"abcd" must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(unit_price: 'abcd') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"123abc"  must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(unit_price: '123abc') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"123@#$"  must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(unit_price: '123@#$') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with integer price' do
      it 'must update successfully' do
        expect(feature.update(unit_price: 4300)).to eq(true)
      end
    end
  end

  describe 'max unit limit validation' do
    context 'with string price' do
      it '"abcd" must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(unit_price: 'abcd') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"123abc" must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(unit_price: '123abc') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"123@#$" must raise ActiveRecord::RecordInvalid' do
        expect { feature.update!(unit_price: '123@#$') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with integer max limit' do
      it '30 must save successfully' do
        feature.max_unit_limit = 30
        expect(feature.save).to eq(true)
      end
    end
  end
end
