class RemoveColumnFromSubscription < ActiveRecord::Migration[5.2]
  def change
    remove_column :subscriptions, :usage
  end
end
