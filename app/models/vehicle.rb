class Vehicle < ApplicationRecord
  belongs_to :user
  has_many :charging_sessions, dependent: :destroy

  validates :brand, :model, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :battery_capacity, :max_charge_power, presence: true, numericality: true
end
