class AddPowerKwToStations < ActiveRecord::Migration[8.1]
  def change
    add_column :stations, :power_kw, :decimal
  end
end
