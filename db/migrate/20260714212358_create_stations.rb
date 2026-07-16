class CreateStations < ActiveRecord::Migration[8.1]
  def change
    create_table :stations do |t|
      t.string :title
      t.string :address_line
      t.string :town
      t.string :province
      t.string :district
      t.decimal :latitude
      t.decimal :longitude
      t.string :connector_type
      t.string :level
      t.integer :quantity
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
