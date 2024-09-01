require 'rails_helper'

RSpec.describe User, type: :model do
  # Valid attributes for creating a valid user
  let(:valid_attributes) { { email: 'admin@example.com', password: 'password123', role: :admin } }
  
  # Invalid attributes for tests
  let(:invalid_attributes) { { email: '', password: '', role: 'invalid_role' } }

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(valid_attributes)
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(valid_attributes.merge(email: ''))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a non-unique email' do
      User.create!(valid_attributes)
      user = User.new(valid_attributes)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'is invalid without a password' do
      user = User.new(valid_attributes.merge(password: ''))
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is invalid with an invalid role' do
      expect {
        User.create!(valid_attributes.merge(role: 'invalid_role'))
      }.to raise_error(ArgumentError, /'invalid_role' is not a valid role/)
    end
  end

  describe '#admin?' do
    it 'returns true if the user is an admin' do
      user = User.create!(valid_attributes)
      expect(user.admin?).to be_truthy
    end
  end
end
