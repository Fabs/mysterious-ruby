require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #sign_in' do
    let(:user_credentials) do
      user = create(:user)
      { username: user.username, password: user.password }
    end

    let(:invalid_user_credentials) do
      user = create(:user)
      { username: user.username, password: 'wrong_value' }
    end

    context 'with valid attributes' do
      render_views

      it 'persists the new user' do
        expect do
          post :sign_in, user: user_credentials, format: 'json'
        end.to change(Session, :count).by(1)
      end

      it 'render a success message with (201)' do
        post(:sign_in, user: user_credentials, format: 'json')
        expect(response).to have_http_status(:created)
      end

      it 'returns the user id' do
        post(:sign_in, user: user_credentials, format: 'json')

        result = JSON.parse(response.body)
        expect(result['session']['token']).to be_present
        expect(result['session']['user_id']).to be_present
        expect(result['session']['role']).to be_present
      end
    end

    context 'with invalid attributes' do
      it 'does not persists a session' do
        credentials = invalid_user_credentials
        expect do
          post :sign_in, user: credentials, format: 'json'
        end.not_to change(User, :count)
      end

      it 'returns error any other case (404)' do
        post(:sign_in, user: invalid_user_credentials, format: 'json')
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #sign_off' do
    let(:session_credentials) do
      user = create(:user)
      session = create(:session, user: user)
      { token: session.token, user_id: session.user.id }
    end

    let(:invalid_session_credentials) do
      user = create(:user)
      create(:session, user: user)
      { token: 'not a valid token', user_id: user.id }
    end

    context 'with valid attributes' do
      render_views

      it 'removes the designed session' do
        credentials = session_credentials
        expect do
          post :sign_off, session: credentials, format: 'json'
        end.to change(Session, :count).by(-1)
      end

      it 'render a success message with (200)' do
        post(:sign_off, session: session_credentials, format: 'json')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      it 'does not persists a session' do
        credentials = invalid_session_credentials
        expect do
          post :sign_off, session: credentials, format: 'json'
        end.not_to change(Session, :count)
      end

      it 'returns error (404)' do
        post(:sign_off, session: invalid_session_credentials, format: 'json')
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #status' do
    context 'with valid attributes' do
      render_views

      it 'renders the server info' do
        get(:status, format: 'json')

        result = JSON.parse(response.body)
        expect(result['status']).to eq('OK')
        expect(result['role']).to eq('guest')
      end
    end

    context 'with invalid attributes' do
    end
  end
end
