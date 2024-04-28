class Booking < ApplicationRecord
  before_create :set_booking_id
  belongs_to :user
  def set_booking_id
    self.booking_id = SecureRandom.uuid
  end
end
