class User < ApplicationRecord
  before_create :set_user_id
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  enum role: { customer: 0, admin: 1 }

  private

  def set_user_id
    self.user_id = SecureRandom.uuid
  end
end