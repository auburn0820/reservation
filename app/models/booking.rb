class Booking < ApplicationRecord
  before_create :set_booking_id, :set_confirmed

  def set_booking_id
    self.booking_id = SecureRandom.uuid
  end

  def set_confirmed
    self.confirmed = false
  end
end
