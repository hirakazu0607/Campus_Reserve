class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :facility

  # Status enum: pending(承認待ち), approved(承認済み), rejected(拒否), cancelled(キャンセル)
  enum :status, { pending: 0, approved: 1, rejected: 2, cancelled: 3 }, default: :pending

  # Validations
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :purpose, length: { maximum: 500 }
  validates :status, presence: true

  # Custom validations
  validate :end_time_after_start_time
  validate :reservation_in_future
  validate :no_time_overlap, on: :create

  private

  # End time must be after start time
  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end

  # Reservation must be in the future
  def reservation_in_future
    return if start_time.blank?

    if start_time < Time.current
      errors.add(:start_time, "must be in the future")
    end
  end

  # Check for overlapping reservations
  def no_time_overlap
    return if facility_id.blank? || start_time.blank? || end_time.blank?

    overlapping = Reservation.where(facility_id: facility_id)
                             .where.not(status: :cancelled)
                             .where("start_time < ? AND end_time > ?", end_time, start_time)

    if overlapping.exists?
      errors.add(:base, "This time slot is already reserved")
    end
  end
end
