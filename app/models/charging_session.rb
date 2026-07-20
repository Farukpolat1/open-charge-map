class ChargingSession < ApplicationRecord
  belongs_to :vehicle

  # Bekleme süresi sabiti
  COOLDOWN_DURATION = 1.minute

  # Her kaydetme işleminden önce kWh hesaplamasını tetikler
  before_save :calculate_kwh_used

  # Temel alan doğrulamaları
  validates :status, presence: true
  validates :power_kw, numericality: { greater_than: 0 }
  validates :duration_minutes, numericality: { greater_than: 0 }, if: -> { status == "completed" }
  validates :amount_paid, numericality: { greater_than_or_equal_to: 0 }, if: -> { status == "completed" }

  # İş kuralları (Business Logic) doğrulamaları
  validate :only_one_active_session_per_user, on: :create
  validate :check_cooldown_period, on: :create

  private

  # kWh Hesaplama Metodu
  def calculate_kwh_used
    if duration_minutes.present? && power_kw.present?
      self.kwh_used = power_kw * (duration_minutes / 60.0)
    end
  end

  # Kural 1: Aynı anda tek aktif şarj
  def only_one_active_session_per_user
    return unless status == "active"

    has_active = vehicle.user.vehicles.joins(:charging_sessions).exists?(charging_sessions: { status: "active" })

    if has_active
      errors.add(:base, "Zaten şu anda aktif olarak devam eden bir şarj oturumunuz var.")
    end
  end

  # Kural 2: Bekleme süresi dolmadan yeni şarj başlatılamaz
  def check_cooldown_period
  last_session = ChargingSession.joins(:vehicle)
                                 .where(vehicles: { user_id: vehicle.user_id }, status: "completed")
                                 .order(started_at: :desc)
                                 .first

  return if last_session.nil?

  last_end_time = last_session.started_at + last_session.duration_minutes.minutes

  if Time.current < (last_end_time + COOLDOWN_DURATION)
    errors.add(:base, "Şarj kilidi aktif. Lütfen bekleme süresinin dolmasını bekleyin.")
  end
  end
end
