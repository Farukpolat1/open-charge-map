class CreateChargingSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :charging_sessions do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.string :station_name
      t.decimal :power_kw
      t.integer :duration_minutes
      t.decimal :amount_paid
      t.decimal :kwh_used
      t.datetime :started_at
      t.string :status

      t.timestamps
    end
  end
end
