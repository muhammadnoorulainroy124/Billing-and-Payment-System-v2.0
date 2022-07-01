class ChangeTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :feature_plans, :usage
    remove_column :feature_plans, :max_unit_limit
    add_column :featrues, :usage, :integer
    add_column :featrues, :max_unit_limit, :integer

  end
end
