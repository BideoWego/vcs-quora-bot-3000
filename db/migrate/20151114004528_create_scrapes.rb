class CreateScrapes < ActiveRecord::Migration
  def change
    create_table :scrapes do |t|
      t.text :data
      t.integer :spreadsheet_id

      t.index :spreadsheet_id

      t.timestamps null: false
    end
  end
end
