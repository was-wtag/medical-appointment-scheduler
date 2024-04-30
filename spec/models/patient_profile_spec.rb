# frozen_string_literal: true

require 'factory_bot'
require 'rails_helper'

RSpec.describe PatientProfile, type: :model do
  context 'when patient profile data is valid' do
    it 'should be valid' do
      patient_profile = FactoryBot.build(:patient_profile_jane_doe)
      expect(patient_profile).to be_valid
    end

    it 'should belong to the user jane doe' do
      patient_profile = FactoryBot.create(:patient_profile_jane_doe)
      expect(patient_profile.user).to eq(User.first)
    end
  end

  context 'when patient profile data is invalid because of missing info' do
    it 'should be invalid without blood_group' do
      patient_profile = FactoryBot.build(:patient_profile_jane_doe, :missing_blood_group)
      expect(patient_profile).not_to be_valid
    end

    it 'should be invalid without height_cm' do
      patient_profile = FactoryBot.build(:patient_profile_jane_doe, :missing_height_cm)
      expect(patient_profile).not_to be_valid
    end

    it 'should be invalid without weight_kg' do
      patient_profile = FactoryBot.build(:patient_profile_jane_doe, :missing_weight_kg)
      expect(patient_profile).not_to be_valid
    end

    it 'should be invalid without nid_number' do
      patient_profile = FactoryBot.build(:patient_profile_jane_doe, :missing_nid_number)
      expect(patient_profile).not_to be_valid
    end
  end

  context 'when patient profile data is invalid because of invalid info' do
    it 'should be invalid with invalid nid_number' do
      patient_profile = FactoryBot.build(:patient_profile_jane_doe, :invalid_nid_number)
      expect(patient_profile).not_to be_valid
    end

    it 'should be invalid with invalid user role' do
      patient_profile = FactoryBot.build(:patient_profile_jane_doe, :invalid_user_role)
      expect(patient_profile).not_to be_valid
    end
  end
end
