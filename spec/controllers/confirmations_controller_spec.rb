RSpec.describe ConfirmationsController, type: :controller do
  let!(:female_user) { FactoryBot.create(:female_user) }

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
      female_user.generate_confirmation_token
      get :show, params: { token: female_user.confirmation_token }
      expect(flash.now[:notice]).to eq('Account confirmation successful')
    end

    it 'should render the show template' do
      female_user.generate_confirmation_token
      get :show, params: { token: female_user.confirmation_token }
      expect(response).to render_template(:show)
    end

    it 'should change user status to active' do
      female_user.generate_confirmation_token
      get :show, params: { token: female_user.confirmation_token }
      female_user.reload
      expect(female_user.status).to eq('active')
    end
  end

  context 'POST #create with invalid email' do
    it 'should return alert message' do
      post :create, params: { email: 'invalid_email' }
      expect(flash[:alert]).to eq('Account can not be confirmed')
    end

    it 'should redirect to new_confirmation_url' do
      post :create, params: { email: 'invalid_email' }
      expect(response).to redirect_to(new_confirmation_url)
    end
  end

  context 'POST #create with valid email' do
    it 'should return notice message' do
      post :create, params: { email: female_user.email }
      expect(flash[:notice]).to eq('Confirmation email sent')
    end

    it 'should redirect to new_confirmation_url' do
      post :create, params: { email: female_user.email }
      expect(response).to redirect_to(new_confirmation_url)
    end

    it 'should re-generate confirmation token' do
      female_user.generate_confirmation_token
      post :create, params: { email: female_user.email }
      expect(assigns(:user).confirmation_token).not_to eq(female_user.confirmation_token)
    end

    it 'should re-send confirmation email' do
      expect do
        post :create, params: { email: female_user.email }
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
