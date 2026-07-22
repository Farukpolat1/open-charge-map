class CreateOcmStations < ActiveRecord::Migration[8.1]
  def change
    create_table :ocm_stations do |t|
      t.integer :ocm_id
      t.string :title
      t.string :address_line
      t.string :town
      t.string :province
      t.decimal :latitude
      t.decimal :longitude
      t.string :connector_type
      t.string :level
      t.integer :quantity
      t.datetime :synced_at

      t.timestamps
    end
    add_index :ocm_stations, :ocm_id, unique: true
  end
end
