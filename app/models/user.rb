class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :stations, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :status_reports, dependent: :destroy
  has_many :station_ratings, dependent: :destroy
  has_many :vehicles, dependent: :destroy


  validates :password, confirmation: true, allow_blank: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
