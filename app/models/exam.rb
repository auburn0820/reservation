class Exam < ApplicationRecord
  before_create :set_exam_id

  def set_exam_id
    self.exam_id = SecureRandom.uuid
  end
end
