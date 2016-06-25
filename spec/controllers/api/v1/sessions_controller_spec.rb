require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user_credentials) do
    user = create(:user)
    { username: user.username, password: user.password }
  end

  let(:invalid_user_credentials) do
    user = create(:user)
    { username: user.username, password: 'wrong_value' }
  end

  let(:invalid_session_credentials) do
    user = create(:user)
    session = create(:session, user: user)
    { token: 'not a valid token', user_id: user.id }
  end

  describe 'POST #sign_in' do

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
end
