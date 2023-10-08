require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'password validations' do
    it 'is valid with a password that meets all requirements' do
      user = User.new(
        email: 'test@example.com',
        password: 'Abc@1234',
        password_confirmation: 'Abc@1234'
      )
      expect(user).to be_valid
    end

    it 'is invalid with a password that does not include a lowercase letter' do
      user = User.new(
        email: 'test@example.com',
        password: 'ABC@1234',
        password_confirmation: 'ABC@1234'
      )
      expect(user).not_to be_valid

      # expect(user.errors[:password]).to include("must include at least one lowercase character")
    end
    it 'is invalid with a password that is too short' do
      user = User.new(
        email: 'test@example.com',
        password: 'Abc@12',
        password_confirmation: 'Abc@12'
      )
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it 'is invalid with a password that is too long' do
      user = User.new(
        email: 'test@example.com',
        password: 'Abc@1234' * 20, 
        password_confirmation: 'Abc@1234' * 20
      )
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too long (maximum is 128 characters)")
    end

  end
end