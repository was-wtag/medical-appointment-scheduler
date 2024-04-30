require 'rails_helper'

RSpec.describe DoctorProfile, type: :model do
  context 'when doctor profile data is valid' do
    it 'should be valid' do
      doctor_profile = FactoryBot.build(:doctor_profile_jane_doe)
      expect(doctor_profile).to be_valid
    end

    it 'should belong to the user jane doe' do
      doctor_profile = FactoryBot.create(:doctor_profile_jane_doe)
      expect(doctor_profile.user).to eq(User.first)
    end
  end

  context 'when doctor profile data is invalid because of missing info' do
    it 'should be invalid without specialty' do
      doctor_profile = FactoryBot.build(:doctor_profile_jane_doe, :missing_specialty)
      expect(doctor_profile).not_to be_valid
    end

    it 'should be invalid without chamber_address' do
      doctor_profile = FactoryBot.build(:doctor_profile_jane_doe, :missing_chamber_address)
      expect(doctor_profile).not_to be_valid
    end

    it 'should be invalid without registration_number' do
      doctor_profile = FactoryBot.build(:doctor_profile_jane_doe, :missing_registration_number)
      expect(doctor_profile).not_to be_valid
    end
  end

  context 'when doctor profile data is invalid because of invalid info' do
    it 'should be invalid with invalid user role' do
      doctor_profile = FactoryBot.build(:doctor_profile_jane_doe, :invalid_user_role)
      expect(doctor_profile).not_to be_valid
    end
  end
end
