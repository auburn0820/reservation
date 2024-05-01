class Exam < ApplicationRecord
  before_create :set_exam_id

  def set_exam_id
    self.exam_id = SecureRandom.uuid
  end

  def can_apply_on_date?
    3.days.from_now < self.started_at.to_time
  end
end
