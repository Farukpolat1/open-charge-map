class CreateStatusReports < ActiveRecord::Migration[8.1]
  def change
    create_table :status_reports do |t|
      t.string :station_identifier, null: false
      t.string :status, null: false
      t.text :comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :status_reports, [ :station_identifier, :created_at ]
  end
end
