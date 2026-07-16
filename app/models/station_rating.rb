class StationRating < ApplicationRecord
  belongs_to :user

  validates :station_identifier, presence: true
  validates :user_id, uniqueness: { scope: :station_identifier }

  def self.counts_by_identifier(identifiers)
    return {} if identifiers.blank?

    where(station_identifier: identifiers).group(:station_identifier, :liked).count
  end
end
