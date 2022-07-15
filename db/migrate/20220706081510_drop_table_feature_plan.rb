# frozen_string_literal: true

# Migration
class DropTableFeaturePlan < ActiveRecord::Migration[5.2]
  def change
    drop_table :feature_plans
  end
end
