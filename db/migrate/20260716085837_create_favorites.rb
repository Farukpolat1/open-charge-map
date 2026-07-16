class CreateFavorites < ActiveRecord::Migration[8.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.string :station_identifier
      t.string :station_title
      t.decimal :station_lat
      t.decimal :station_lng

      t.timestamps
    end
    add_index :favorites, [ :user_id, :station_identifier ], unique: true
  end
end
