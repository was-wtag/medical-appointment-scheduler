# frozen_string_literal: true

require 'factory_bot'
require 'rails_helper'

RSpec.describe ConfirmationsController, type: :controller do
  let!(:user_jane_doe) { FactoryBot.create(:user_jane_doe) }

  context 'GET #new' do
    it 'should return success response' do
      get :new
      expect(response).to be_successful
    end

    it 'should render the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  context 'GET #show with invalid token' do
    it 'should return alert message' do
      get :show, params: { token: 'invalid_token' }
      expect(flash.now[:alert]).to eq('Account confirmation failed')
    end

    it 'should render the show template' do
      get :show, params: { token: 'invalid_token' }
      expect(response).to render_template(:show)
    end
  end

  context 'GET #show with valid token' do
    it 'should return notice message' do
      user_jane_doe.generate_confirmation_token
      get :show, params: { token: user_jane_doe.confirmation_token }
      expect(flash.now[:notice]).to eq('Account confirmation successful')
    end

    it 'should render the show template' do
      user_jane_doe.generate_confirmation_token
      get :show, params: { token: user_jane_doe.confirmation_token }
      expect(response).to render_template(:show)
    end

    it 'should change user status to active' do
      user_jane_doe.generate_confirmation_token
      get :show, params: { token: user_jane_doe.confirmation_token }
      user_jane_doe.reload
      expect(user_jane_doe.status).to eq('active')
    end
  end

  context 'POST #create with invalid email' do
    it 'should return alert message' do
      get :create, params: { email: 'invalid_email' }
      expect(flash[:alert]).to eq('Account can not be confirmed')
    end

    it 'should redirect to new_confirmation_url' do
      get :create, params: { email: 'invalid_email' }
      expect(response).to redirect_to(new_confirmation_url)
    end
  end

  context 'POST #create with valid email' do
    it 'should return notice message' do
      get :create, params: { email: user_jane_doe.email }
      expect(flash[:notice]).to eq('Confirmation email sent')
    end

    it 'should redirect to new_confirmation_url' do
      get :create, params: { email: user_jane_doe.email }
      expect(response).to redirect_to(new_confirmation_url)
    end

    it 'should re-generate confirmation token' do
      user_jane_doe.generate_confirmation_token
      get :create, params: { email: user_jane_doe.email }
      expect(assigns(:user).confirmation_token).not_to eq(user_jane_doe.confirmation_token)
    end

    it 'should re-send confirmation email' do
      expect do
        get :create, params: { email: user_jane_doe.email }
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
