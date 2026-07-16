class CreateStationRatings < ActiveRecord::Migration[8.1]
  def change
    create_table :station_ratings do |t|
      t.string :station_identifier, null: false
      t.boolean :liked, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :station_ratings, [ :user_id, :station_identifier ], unique: true
  end
end
