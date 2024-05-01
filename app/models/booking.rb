class Booking < ApplicationRecord
  before_create :set_booking_id, :set_status

  module Status
    PENDING = "pending"
    CONFIRMED = "confirmed"
    CANCELED = "canceled"
  end.freeze

  enum status: { pending: Status::PENDING, confirmed: Status::CONFIRMED, canceled: Status::CANCELED }

  def confirm
    self.update_attribute(:status, Status::CONFIRMED)
  end

  def cancel
    self.update_attribute(:status, Status::CANCELED)
  end

  def set_booking_id
    self.booking_id = SecureRandom.uuid
  end

  def is_canceled?
    self.status == Booking::Status::CANCELED
  end

  def is_cancelable_status?
    self.status != Booking::Status::CONFIRMED
  end

  def set_status
    self.status = Status::PENDING
  end

  def change_exam(exam_id)
    self.update_attribute(:exam_id, exam_id)
  end

  def self.can_reserve_seat?(exam_id)
    Booking.where(exam_id: exam_id, status: Booking::Status::CONFIRMED).count < Constants::BOOKING_LIMIT_COUNT
  end

  def self.is_already_booked?(user_id:, exam_id:)
    Booking.exists?(exam_id: exam_id, user_id: user_id)
  end
end
