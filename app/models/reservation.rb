class Reservation < ApplicationRecord
  belongs_to :facility

  validates :user_name, presence: true
  validates :user_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :purpose, presence: true
  validate :end_time_after_start_time
  validate :no_overlapping_reservations

  STATUSES = ['pending', 'confirmed', 'cancelled'].freeze
  validates :status, inclusion: { in: STATUSES }

  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= 'pending'
  end

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, I18n.t('activerecord.errors.models.reservation.attributes.end_time.after_start_time'))
    end
  end

  def no_overlapping_reservations
    return if start_time.blank? || end_time.blank? || facility_id.blank?

    overlapping = Reservation.where(facility_id: facility_id)
                             .where.not(id: id)
                             .where.not(status: 'cancelled')
                             .where("start_time < ? AND end_time > ?", end_time, start_time)

    if overlapping.exists?
      errors.add(:base, I18n.t('activerecord.errors.models.reservation.attributes.base.overlapping'))
    end
  end
end
