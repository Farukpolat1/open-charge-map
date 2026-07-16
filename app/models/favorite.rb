class Favorite < ApplicationRecord
  belongs_to :user
  validates :station_identifier, presence: true
  validates :station_identifier, uniqueness: { scope: :user_id }
end
