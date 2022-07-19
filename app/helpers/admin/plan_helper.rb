# frozen_string_literal: true

module Admin::PlanHelper
  def all_features
    Feature.all
  end
end
