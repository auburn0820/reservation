class User < ApplicationRecord
  before_create :set_user_id
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  module Role
    CUSTOMER = "customer"
    ADMIN = "admin"
  end.freeze

  enum role: { customer: Role::CUSTOMER, admin: Role::ADMIN }

  private

  def set_user_id
    self.user_id = SecureRandom.uuid
  end
end