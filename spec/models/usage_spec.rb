# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Usage, type: :model do
  describe 'associations' do
    context 'when created' do
      it { is_expected.to belong_to(:subscription) }
      it { is_expected.to belong_to(:feature) }
    end
  end
end
