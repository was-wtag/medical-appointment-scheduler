# frozen_string_literal: true

require 'factory_bot'
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user_jane_doe) { FactoryBot.create(:user_jane_doe) }

  context 'GET #index when not authenticated' do
    it 'should return alert message' do
      get :index
      expect(flash[:alert]).to eq('You must be logged in to access this page')
    end

    it 'should redirect to the sign in page' do
      get :index
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'GET #index when authenticated' do
    before do
      allow(controller).to receive(:authenticate!).and_return(true)
    end

    it 'should assign all users as @users' do
      get :index
      expect(assigns(:users)).to eq([user_jane_doe])
    end

    it 'should render the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'should return a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  context 'GET #show when not authenticated' do
    it 'should return alert message' do
      get :show, params: { id: user_jane_doe.id }
      expect(flash[:alert]).to eq('You must be logged in to access this page')
    end

    it 'should redirect to the sign in page' do
      get :show, params: { id: user_jane_doe.id }
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'GET #show when authenticated' do
    before do
      allow(controller).to receive(:authenticate!).and_return(true)
    end

    it 'should assign the requested user as @user' do
      get :show, params: { id: user_jane_doe.id }
      expect(assigns(:user)).to eq(user_jane_doe)
    end

    it 'should render the show template' do
      get :show, params: { id: user_jane_doe.id }
      expect(response).to render_template('show')
    end

    it 'should return a success response' do
      get :show, params: { id: user_jane_doe.id }
      expect(response).to be_successful
    end
  end

  context 'GET #new when already authenticated' do
    before do
      allow(controller).to receive(:current_user).and_return(user_jane_doe)
    end

    it 'should redirect to the root page' do
      get :new
      expect(response).to redirect_to(root_url)
    end
  end

  context 'GET #new when not authenticated' do
    before do
      allow(controller).to receive(:do_not_authenticate!).and_return(true)
    end

    it 'should assign a new user as @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'should render the new template' do
      get :new
      expect(response).to render_template('new')
    end

    it 'should return a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  context 'GET #edit when not authenticated' do
    it 'should return alert message' do
      get :edit, params: { id: user_jane_doe.id }
      expect(flash[:alert]).to eq('You must be logged in to access this page')
    end

    it 'should redirect to the sign in page' do
      get :edit, params: { id: user_jane_doe.id }
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'GET #edit when authenticated' do
    before do
      allow(controller).to receive(:authenticate!).and_return(true)
    end

    it 'should assign the requested user as @user' do
      get :edit, params: { id: user_jane_doe.id }
      expect(assigns(:user)).to eq(user_jane_doe)
    end

    it 'should render the edit template' do
      get :edit, params: { id: user_jane_doe.id }
      expect(response).to render_template('edit')
    end

    it 'should return a success response' do
      get :edit, params: { id: user_jane_doe.id }
      expect(response).to be_successful
    end
  end

  context 'POST #create with valid params' do
    before do
      post :create,
           params: { '[user]' => FactoryBot.attributes_for(:user_john_doe),
                     '[patient_profile]' => FactoryBot.attributes_for(:patient_profile_jane_doe,
                                                                      :without_user_for_signup) }
    end

    it 'should assign a newly created user as @user' do
      expect(assigns(:user)).to be_a(User)
    end

    it 'should save a newly created user to database' do
      expect(assigns(:user)).to be_persisted
    end

    it 'should assign a newly created patient profile as @profile' do
      expect(assigns(:profile)).to be_a(PatientProfile)
    end

    it 'should assign @user as the owner of @profile' do
      expect(assigns(:profile).user).to eq(assigns(:user))
    end

    it 'should save a newly created patient profile to database' do
      expect(assigns(:profile)).to be_persisted
    end

    it 'should redirect to the created user' do
      expect(response).to redirect_to(assigns(:user))
    end

    it 'should generate a confirmation token' do
      expect(assigns(:user).confirmation_token).not_to be_nil
    end

    it 'should send a confirmation email' do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  context 'POST #create with invalid params because of missing names' do
    it 'should assign a newly created but unsaved user as @user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_first_name) }
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'should not save the new user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_first_name) }
      expect(assigns(:user)).not_to be_persisted
    end

    it 'should render the new template' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_first_name) }
      expect(response).to render_template('new')
    end

    it 'should return an unprocessable entity response' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_first_name) }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'POST #create with invalid params because of missing contact information' do
    it 'should assign a newly created but unsaved user as @user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_email) }
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'should not save the new user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_email) }
      expect(assigns(:user)).not_to be_persisted
    end

    it 'should render the new template' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_email) }
      expect(response).to render_template('new')
    end

    it 'should return an unprocessable entity response' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_email) }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'POST #create with invalid params because of missing password information' do
    it 'should assign a newly created but unsaved user as @user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_password) }
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'should not save the new user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_password) }
      expect(assigns(:user)).not_to be_persisted
    end

    it 'should render the new template' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_password) }
      expect(response).to render_template('new')
    end

    it 'should return an unprocessable entity response' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :missing_password) }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'POST #create with invalid params because of invalid format' do
    it 'should assign a newly created but unsaved user as @user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :invalid_email) }
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'should not save the new user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :invalid_email) }
      expect(assigns(:user)).not_to be_persisted
    end

    it 'should render the new template' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :invalid_email) }
      expect(response).to render_template('new')
    end

    it 'should return an unprocessable entity response' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :invalid_email) }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'POST #create with invalid params because of duplicate email' do
    it 'should assign a newly created but unsaved user as @user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :duplicate_email) }
      expect(assigns(:user)).to be_a(User)
    end

    it 'should not save the new user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :duplicate_email) }
      expect(assigns(:user)).not_to be_persisted
    end

    it 'should render the new template' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :duplicate_email) }
      expect(response).to render_template('new')
    end

    it 'should return an unprocessable entity response' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :duplicate_email) }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'POST #create with invalid params because of duplicate phone number' do
    it 'should assign a newly created but unsaved user as @user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :duplicate_phone_number) }
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'should not save the new user' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :duplicate_phone_number) }
      expect(assigns(:user)).not_to be_persisted
    end

    it 'should render the new template' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :duplicate_phone_number) }
      expect(response).to render_template('new')
    end

    it 'should return an unprocessable entity response' do
      post :create, params: { user: FactoryBot.attributes_for(:user_john_doe, :duplicate_phone_number) }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'PATCH #update when authenticated' do
    before do
      allow(controller).to receive(:authenticate!).and_return(true)
      patch :update,
            params: { id: user_jane_doe.id, user: FactoryBot.attributes_for(:user_jane_doe, :update_status_to_active) }
    end

    it 'should assign the user as @user' do
      expect(assigns(:user)).to eq(user_jane_doe)
    end

    it 'should update the user' do
      expect(User.first.reload.status).to eq('active')
    end

    it 'should redirect to the user' do
      expect(response).to redirect_to(user_jane_doe)
    end
  end

  context 'PATCH #update when not authenticated' do
    before do
      patch :update,
            params: { id: user_jane_doe.id, user: FactoryBot.attributes_for(:user_jane_doe, :update_status_to_active) }
    end

    it 'should return alert message' do
      expect(flash[:alert]).to eq('You must be logged in to access this page')
    end

    it 'should redirect to the sign in page' do
      expect(response).to redirect_to(new_auth_url)
    end
  end

  context 'DELETE #destroy when authenticated' do
    before do
      allow(controller).to receive(:authenticate!).and_return(true)
    end

    it 'should destroy the requested user' do
      delete :destroy, params: { id: user_jane_doe.id }
      expect(User.count).to eq(0)
    end

    it 'should redirect to the users list' do
      delete :destroy, params: { id: user_jane_doe.id }
      expect(response).to redirect_to(users_url)
    end
  end

  context 'DELETE #destroy when not authenticated' do
    before do
      delete :destroy, params: { id: user_jane_doe.id }
    end

    it 'should return alert message' do
      expect(flash[:alert]).to eq('You must be logged in to access this page')
    end

    it 'should redirect to the sign in page' do
      expect(response).to redirect_to(new_auth_url)
    end
  end
end
