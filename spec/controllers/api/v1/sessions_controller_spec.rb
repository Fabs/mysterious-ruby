require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  before(:each) do
    allow(request.env['warden']).to receive(:authenticate!)

    Api::ApiController.any_instance.stub(:role).and_return(:guest)
  end

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

      it 'returns the correct role'
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

      it { expect(response).to have_http_status(:ok) }

      it 'renders the server info' do
        get(:status, format: 'json')

        result = JSON.parse(response.body)
        expect(result['status']).to eq('OK')
        expect(result['role']).to eq('guest')
      end
    end

    # TODO: A god place to remove duplication with custom matchers
    # TODO: This also looks more like integration
    context 'with valid user token' do
      render_views

      let(:session) { create(:session) }

      it { expect(response).to have_http_status(:ok) }

      it 'renders the server info for user' do
        pending
        request.headers['X-User-Token'] = session.token
        request.headers['X-User-Id'] = session.user_id
        get(:status, format: 'json')

        result = JSON.parse(response.body)
        expect(result['status']).to eq('OK')
        expect(result['role']).to eq('user')
      end
    end

    context 'with valid user token for admin' do
      render_views

      let(:session) { create(:session, user: create(user, admin: true)) }

      it { expect(response).to have_http_status(:ok) }

      it 'renders the server info for admin' do
        pending
        request.headers['X-User-Token'] = session.token
        request.headers['X-User-Id'] = session.user_id
        get(:status, format: 'json')

        result = JSON.parse(response.body)
        expect(result['status']).to eq('OK')
        expect(result['role']).to eq('admin')
      end
    end

    context 'with invalid user token' do
      render_views

      let(:session) do
        create(:session, user: create(user, admin: true))
        OpenStruct.new(token: 'invalid_token', user_id: 1)
      end

      it do
        pending
        expect(response).to(have_http_status(:not_found))
      end

      it 'renders the server info' do
        pending
        request.headers['X-User-Token'] = ''
        request.headers['X-User-Id'] = ''
        get(:status, format: 'json')

        result = JSON.parse(response.body)
        expect(result['status']).to eq('OK')
        expect(result['role']).to eq('forbidden')
      end
    end
  end
end
