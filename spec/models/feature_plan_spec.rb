# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeaturePlan, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to belong_to(:feature) }
  end
end
