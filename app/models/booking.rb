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

  def set_status
    self.status = Status::PENDING
  end
end
