class StatusReport < ApplicationRecord
  belongs_to :user

  STATUSES = %w[working broken]

  validates :station_identifier, presence: true
  validates :status, inclusion: { in: STATUSES }

  def self.latest_for(station_identifier)
    where(station_identifier: station_identifier).order(created_at: :desc).first
  end

  def self.latest_by_identifier(identifiers)
    return {} if identifiers.blank?

    where(station_identifier: identifiers)
      .order(created_at: :desc)
      .group_by(&:station_identifier)
      .transform_values(&:first)
  end
end
