class AddDetailsToVehicles < ActiveRecord::Migration[8.1]
  def change
    add_column :vehicles, :year, :integer
    add_column :vehicles, :battery_capacity, :decimal
    add_column :vehicles, :max_charge_power, :decimal
  end
end
