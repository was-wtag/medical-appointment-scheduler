# frozen_string_literal: true

require 'factory_bot'
require 'rails_helper'

RSpec.describe ProfileController, type: :controller do
  context 'GET #show when not authenticated' do
    it 'should return alert message' do
      get :show
      expect(flash[:alert]).to eq('You must be logged in to access this page')
    end

    it 'should redirect to login page' do
      get :show
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'GET #show when authenticated as a doctor' do
    let!(:doctor_profile_jane_doe) { FactoryBot.create(:doctor_profile_jane_doe) }

    before do
      allow(controller).to receive(:current_user).and_return(doctor_profile_jane_doe.user)
      get :show
    end

    it 'should assign the current_profile' do
      expect(controller.current_profile).to eq(doctor_profile_jane_doe)
    end

    it 'should assign the current_profile_partial' do
      expect(controller.current_profile_partial).to eq('doctor_profile')
    end

    it 'should return success response' do
      expect(response).to be_successful
    end

    it 'should render the show template' do
      expect(response).to render_template(:show)
    end
  end

  context 'GET #show when authenticated as a patient' do
    let!(:patient_profile_jane_doe) { FactoryBot.create(:patient_profile_jane_doe) }

    before do
      allow(controller).to receive(:current_user).and_return(patient_profile_jane_doe.user)
      get :show
    end

    it 'should assign the current_profile' do
      expect(controller.current_profile).to eq(patient_profile_jane_doe)
    end

    it 'should assign the current_profile_partial' do
      expect(controller.current_profile_partial).to eq('patient_profile')
    end

    it 'should return success response' do
      expect(response).to be_successful
    end

    it 'should render the show template' do
      expect(response).to render_template(:show)
    end
  end

  context 'GET #edit when not authenticated' do
    it 'should return alert message' do
      get :edit
      expect(flash[:alert]).to eq('You must be logged in to access this page')
    end

    it 'should redirect to login page' do
      get :edit
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'GET #edit when authenticated as a doctor' do
    let!(:doctor_profile_jane_doe) { FactoryBot.create(:doctor_profile_jane_doe) }

    before do
      allow(controller).to receive(:current_user).and_return(doctor_profile_jane_doe.user)
      get :edit
    end

    it 'should assign the current_profile' do
      expect(controller.current_profile).to eq(doctor_profile_jane_doe)
    end

    it 'should assign the current_profile_partial' do
      expect(controller.current_profile_partial).to eq('doctor_profile')
    end

    it 'should return success response' do
      expect(response).to be_successful
    end

    it 'should render the edit template' do
      expect(response).to render_template(:edit)
    end
  end

  context 'GET #edit when authenticated as a patient' do
    let!(:patient_profile_jane_doe) { FactoryBot.create(:patient_profile_jane_doe) }

    before do
      allow(controller).to receive(:current_user).and_return(patient_profile_jane_doe.user)
      get :edit
    end

    it 'should assign the current_profile' do
      expect(controller.current_profile).to eq(patient_profile_jane_doe)
    end

    it 'should assign the current_profile_partial' do
      expect(controller.current_profile_partial).to eq('patient_profile')
    end

    it 'should return success response' do
      expect(response).to be_successful
    end

    it 'should render the edit template' do
      expect(response).to render_template(:edit)
    end
  end

  context 'PATCH #update when not authenticated' do
    it 'should return alert message' do
      patch :update
      expect(flash[:alert]).to eq('You must be logged in to access this page')
    end

    it 'should redirect to login page' do
      patch :update
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'PATCH #update when authenticated as a doctor' do
    let!(:doctor_profile_jane_doe) { FactoryBot.create(:doctor_profile_jane_doe) }

    context 'with valid params' do
      before do
        allow(controller).to receive(:current_user).and_return(doctor_profile_jane_doe.user)
        patch :update,
              params: { doctor_profile: FactoryBot.attributes_for(:doctor_profile_jane_doe, :update_specialty) }
      end

      it 'should update the doctor profile' do
        expect(doctor_profile_jane_doe.reload.specialty).to eq('cardiologist')
      end

      it 'should redirect to edit_profile_url' do
        expect(response).to redirect_to(edit_profile_url)
      end

      it 'should return notice message' do
        expect(flash[:notice]).to eq('Profile was successfully updated.')
      end
    end

    context 'with invalid params' do
      before do
        allow(controller).to receive(:current_user).and_return(doctor_profile_jane_doe.user)
        patch :update,
              params: { doctor_profile: FactoryBot.attributes_for(:doctor_profile_jane_doe, :missing_specialty) }
      end

      it 'should not update the doctor profile' do
        expect(doctor_profile_jane_doe.reload.specialty).to eq('general')
      end

      it 'should return unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should render the edit template' do
        expect(response).to render_template(:edit)
      end
    end
  end

  context 'PATCH #update when authenticated as a patient' do
    let!(:patient_profile_jane_doe) { FactoryBot.create(:patient_profile_jane_doe) }

    context 'with valid params' do
      before do
        allow(controller).to receive(:current_user).and_return(patient_profile_jane_doe.user)
        patch :update,
              params: { patient_profile: FactoryBot.attributes_for(:patient_profile_jane_doe, :update_blood_group) }
      end

      it 'should update the patient profile' do
        expect(patient_profile_jane_doe.reload.blood_group).to eq('a_negative')
      end

      it 'should redirect to edit_profile_url' do
        expect(response).to redirect_to(edit_profile_url)
      end

      it 'should return notice message' do
        expect(flash[:notice]).to eq('Profile was successfully updated.')
      end
    end

    context 'with invalid params' do
      before do
        allow(controller).to receive(:current_user).and_return(patient_profile_jane_doe.user)
        patch :update,
              params: { patient_profile: FactoryBot.attributes_for(:patient_profile_jane_doe, :missing_blood_group) }
      end

      it 'should not update the patient profile' do
        expect(patient_profile_jane_doe.reload.blood_group).to eq('a_positive')
      end

      it 'should return unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'should render the edit template' do
        expect(response).to render_template(:edit)
      end
    end
  end
end
