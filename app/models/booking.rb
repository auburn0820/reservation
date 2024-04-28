class Booking < ApplicationRecord
  before_create :set_booking_id, :set_status

  enum status: { pending: "pending", confirmed: "confirmed", canceled: "canceled" }

  def confirm
    self.update_attribute(:status, "confirmed")
  end

  def cancel
    self.update_attribute(:status, "canceled")
  end

  def set_booking_id
    self.booking_id = SecureRandom.uuid
  end

  def set_status
    self.status = "pending"
  end
end
