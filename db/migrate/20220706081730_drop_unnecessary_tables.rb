# frozen_string_literal: true

# Migration
class DropUnnecessaryTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :books
    drop_table :featrues
  end
end
