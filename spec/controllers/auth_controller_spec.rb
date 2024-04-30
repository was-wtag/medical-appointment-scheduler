# frozen_string_literal: true

require 'factory_bot'
require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let!(:user_jane_doe) { FactoryBot.create(:user_jane_doe) }

  context 'GET #new when not authenticated' do
    before do
      get :new
    end

    it 'should return success response' do
      expect(response).to be_successful
    end

    it 'should render the new template' do
      expect(response).to render_template(:new)
    end
  end

  context 'GET #new when already authenticated' do
    it 'should redirect to root_url' do
      allow(controller).to receive(:current_user).and_return(user_jane_doe)
      get :new
      expect(response).to redirect_to(root_url)
    end
  end

  context 'POST #create with invalid email' do
    before do
      post :create, params: FactoryBot.attributes_for(:user_jane_doe, :inavlid_email_for_login)
    end

    it 'should return alert message' do
      expect(flash[:alert]).to eq('Invalid email or password')
    end

    it 'should redirect to new_auth_url' do
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'POST #create with invalid password' do
    before do
      post :create, params: FactoryBot.attributes_for(:user_jane_doe, :inavlid_password_for_login)
    end

    it 'should return alert message' do
      expect(flash[:alert]).to eq('Invalid email or password')
    end

    it 'should redirect to new_auth_url' do
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'POST #create with inactive user' do
    before do
      post :create, params: FactoryBot.attributes_for(:user_jane_doe)
    end

    it 'should return alert message' do
      expect(flash[:alert]).to eq('Account not active')
    end

    it 'should redirect to new_auth_url' do
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'POST #create with valid email, password and active user' do
    before do
      user_jane_doe.active!
      post :create, params: FactoryBot.attributes_for(:user_jane_doe)
    end

    it 'should set current_user' do
      expect(session[:current_user]).to eq(user_jane_doe)
    end

    it 'should set jwt cookie' do
      expect(cookies[:jwt]).to be_present
    end

    it 'should redirect to root_url' do
      expect(response).to redirect_to(root_url)
    end
  end

  context 'POST #create when already authenticated' do
    it 'should redirect to root_url' do
      allow(controller).to receive(:current_user).and_return(user_jane_doe)
      post :create, params: FactoryBot.attributes_for(:user_jane_doe)
      expect(response).to redirect_to(root_url)
    end
  end

  context 'DELETE #destroy when authenticated' do
    before do
      user_jane_doe.active!
      post :create, params: FactoryBot.attributes_for(:user_jane_doe)
    end

    it 'should delete current_user' do
      expect { delete :destroy }.to change { session[:current_user] }.from(user_jane_doe).to(nil)
    end

    it 'should delete jwt cookie' do
      expect { delete :destroy }.to change { request.cookie_jar[:jwt] }.from(anything).to(nil)
    end

    it 'should redirect to new_auth_url' do
      delete :destroy
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'DELETE #destroy when not authenticated' do
    before do
      delete :destroy
    end

    it 'should return alert message' do
      expect(flash[:alert]).to eq('You must be logged in to access this page')
    end

    it 'should redirect to new_auth_url' do
      expect(response).to redirect_to(new_auth_url)
    end
  end
end
