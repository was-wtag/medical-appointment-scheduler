# frozen_string_literal: true

require 'factory_bot'
require 'rails_helper'

RSpec.describe 'User', type: :model do
  before do
    FactoryBot.create(:user_jane_doe)
  end

  context 'when user data is valid' do
    it 'should be valid' do
      user = FactoryBot.build(:user_john_doe)
      expect(user).to be_valid
    end
  end

  context 'when user data is invalid because of missing names' do
    it 'should be invalid without first_name' do
      user = FactoryBot.build(:user_john_doe, :missing_first_name)
      expect(user).not_to be_valid
    end

    it 'should be invalid without last_name' do
      user = FactoryBot.build(:user_john_doe, :missing_last_name)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of missing contact information' do
    it 'should be invalid without email' do
      user = FactoryBot.build(:user_john_doe, :missing_email)
      expect(user).not_to be_valid
    end

    it 'should be invalid without phone_number' do
      user = FactoryBot.build(:user_john_doe, :missing_phone_number)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of missing password information' do
    it 'should be invalid without password' do
      user = FactoryBot.build(:user_john_doe, :missing_password)
      expect(user).not_to be_valid
    end

    it 'should be invalid without password_confirmation' do
      user = FactoryBot.build(:user_john_doe, :missing_password_confirmation)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of invalid format' do
    it 'should be invalid with invalid email' do
      user = FactoryBot.build(:user_john_doe, :invalid_email)
      expect(user).not_to be_valid
    end

    it 'should be invalid with invalid phone_number' do
      user = FactoryBot.build(:user_john_doe, :invalid_phone_number)
      expect(user).not_to be_valid
    end

    it 'should be invalid with password too short' do
      user = FactoryBot.build(:user_john_doe, :password_too_short)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of info mismatch' do
    it 'should be invalid with password_confirmation mismatch' do
      user = FactoryBot.build(:user_john_doe, :password_confirmation_mismatch)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of duplicate info' do
    it 'should be invalid with duplicate email' do
      user = FactoryBot.build(:user_john_doe, :duplicate_email)
      expect(user).not_to be_valid
    end

    it 'should be invalid with duplicate phone_number' do
      user = FactoryBot.build(:user_john_doe, :duplicate_phone_number)
      expect(user).not_to be_valid
    end
  end
end
