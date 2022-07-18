class ChangeFeatureTable < ActiveRecord::Migration[5.2]
  def change
    change_table :features do |t|
      t.change :code, :string
    end
  end
end
