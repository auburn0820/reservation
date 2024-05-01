class Exam < ApplicationRecord
  before_create :set_exam_id, :set_status

  module Status
    ACTIVATED = "activated"
    DELETED = "deleted"
  end.freeze

  enum status: { active: Status::ACTIVATED, deleted: Status::DELETED }

  def set_status
    self.status = Status::ACTIVATED
  end

  def set_exam_id
    self.exam_id = SecureRandom.uuid
  end

  def set_delete
    self.update_attribute(:status, Status::DELETED)
  end

  def can_apply_on_date?
    3.days.from_now < self.started_at.to_time
  end

  def is_already_ended?
    self.ended_at.to_time < Time.current
  end
end
