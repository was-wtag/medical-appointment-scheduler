RSpec.describe User, type: :model do
  before do
    FactoryBot.create(:female_user)
  end

  context 'when user data is valid' do
    let!(:user) { FactoryBot.build(:male_user) }

    it { is_expected.to define_enum_for(:role).with_values(%i[admin doctor patient]) }

    it { is_expected.to define_enum_for(:gender).with_values(%i[not_specified female male]) }

    it 'should be valid' do
      expect(user).to be_valid
    end

    it 'should have proper role' do
      expect(user.role).to eq(FactoryBot.attributes_for(:male_user)[:role])
    end

    it 'should have proper gender' do
      expect(user.gender).to eq(FactoryBot.attributes_for(:male_user)[:gender])
    end

    it 'should have proper status' do
      expect(user.status).to eq('pending')
    end
  end

  context 'when user data is invalid because of missing names' do
    it 'should be invalid without first_name' do
      user = FactoryBot.build(:male_user, :missing_first_name)
      expect(user).not_to be_valid
    end

    it 'should be invalid without last_name' do
      user = FactoryBot.build(:male_user, :missing_last_name)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of missing contact information' do
    it 'should be invalid without email' do
      user = FactoryBot.build(:male_user, :missing_email)
      expect(user).not_to be_valid
    end

    it 'should be invalid without phone_number' do
      user = FactoryBot.build(:male_user, :missing_phone_number)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of missing password information' do
    it 'should be invalid without password' do
      user = FactoryBot.build(:male_user, :missing_password)
      expect(user).not_to be_valid
    end

    it 'should be invalid without password_confirmation' do
      user = FactoryBot.build(:male_user, :missing_password_confirmation)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of invalid format' do
    it 'should be invalid with invalid email' do
      user = FactoryBot.build(:male_user, :invalid_email)
      expect(user).not_to be_valid
    end

    it 'should be invalid with invalid phone_number' do
      user = FactoryBot.build(:male_user, :invalid_phone_number)
      expect(user).not_to be_valid
    end

    it 'should be invalid with password too short' do
      user = FactoryBot.build(:male_user, :password_too_short)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of info mismatch' do
    it 'should be invalid with password_confirmation mismatch' do
      user = FactoryBot.build(:male_user, :password_confirmation_mismatch)
      expect(user).not_to be_valid
    end
  end

  context 'when user data is invalid because of duplicate info' do
    it 'should be invalid with duplicate email' do
      user = FactoryBot.build(:male_user, :duplicate_email)
      expect(user).not_to be_valid
    end

    it 'should be invalid with duplicate phone_number' do
      user = FactoryBot.build(:male_user, :duplicate_phone_number)
      expect(user).not_to be_valid
    end
  end
end
