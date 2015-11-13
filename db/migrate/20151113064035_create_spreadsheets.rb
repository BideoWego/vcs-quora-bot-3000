class CreateSpreadsheets < ActiveRecord::Migration
  def change
    create_table :spreadsheets do |t|
      t.string :key
      t.string :data_gid
      t.string :map_gid

      t.index :key, :unique => true
      t.index :data_gid
      t.index :map_gid

      t.timestamps null: false
    end
  end
end
