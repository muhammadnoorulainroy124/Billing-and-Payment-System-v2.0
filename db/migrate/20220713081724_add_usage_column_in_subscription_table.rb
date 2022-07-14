class AddUsageColumnInSubscriptionTable < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :usage, :integer, null: false, default: 0
    remove_column :features, :usage
  end
end
