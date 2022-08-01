# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'callbacks' do
    context 'when creating user' do
      it { is_expected.to callback(:create_stripe_reference).before(:validation).on(%i[create update]) }
    end
  end

  describe 'DB constraint' do
    context 'when user table created' do
      it { is_expected.to have_db_column(:type).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:stripe_id).of_type(:string) }
      it { is_expected.to have_db_index(:email) }
      it { is_expected.to have_db_index(:stripe_id) }
    end
  end

  describe 'validation' do
    context 'when validating user' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      it { is_expected.to validate_confirmation_of(:password) }
      it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(20) }
    end
  end

  describe 'name validation' do
    context 'with special characters and digits' do
      it '"Noor@332" must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(name: 'Noor@') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"Noor!" must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(name: 'Noor!') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"Noor&*$" must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(name: 'Noor&*$432') }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it '"Noor~<>()" must must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(name: 'Noor~<>()43') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with digits' do
      it 'Noorulain12 raise ActiveRecord::RecordInvalid' do
        expect { user.update!(name: 'Noorulain12') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with digits and symbols' do
      it 'must update successfully' do
        expect(user.update(name: 'Noorulain')).to eq(true)
      end
    end
  end

  describe 'password validation' do
    context 'when no symbols' do
      it 'must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(password: 'Noorulain12') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when no digits' do
      it 'must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(password: 'Noorulain@') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when no uppercase letter' do
      it 'must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(password: 'noorulain@1') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when no lower case letter' do
      it 'must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(password: 'NOORULAIN@1') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when no letter' do
      it 'must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(password: '323223#$%@1') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when less than 8 characters' do
      it 'must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(password: 'Noor@1') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with 8 characters, uppercase, lowercase, digit and symbol' do
      it 'must update successfully' do
        expect(user.update(password: 'Noorulain@1')).to eq(true)
      end
    end
  end

  describe 'email validation' do
    context 'when no @' do
      it 'must raise ActiveRecord::RecordInvalid' do
        expect { user.update!(email: 'Noorgmail.com') }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with' do
      it 'must raise ActiveRecord::RecordInvalid' do
        expect(user.update!(email: 'Noor@gmail.com')).to eq(true)
      end
    end
  end

  describe 'stripe reference' do
    context 'when creating' do
      it 'must create stripe reference' do
        expect(user.create_stripe_reference).to eq(user.stripe_id)
      end
    end
  end

  describe 'retrieve stripe reference' do
    context 'when retrieving' do
      it 'must return stripe reference' do
        expect(user.retrieve_stripe_reference.id).to eq(user.stripe_id)
      end
    end
  end
end
