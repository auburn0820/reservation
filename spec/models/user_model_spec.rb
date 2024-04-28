require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'is not valid without an email' do
    user.email = nil
    expect(user).not_to be_valid
  end

  it 'is not valid with a duplicate email' do
    user.save!
    duplicate_user = build(:user, email: user.email)
    expect(duplicate_user).not_to be_valid
  end

  it 'is not valid with a password length less than 6 characters' do
    user.password = '12345'
    expect(user).not_to be_valid
  end

  it 'is not valid with a password length more than 128 characters' do
    user.password = 'a' * 129
    expect(user).not_to be_valid
  end

  it 'is valid with a password length between 6 and 128 characters' do
    user.password = 'a' * 64
    expect(user).to be_valid
  end

  it 'is not valid with an incorrectly formatted email' do
    user.email = 'invalid_email'
    expect(user).not_to be_valid
  end
end