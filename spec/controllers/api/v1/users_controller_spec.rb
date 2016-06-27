require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) do
    allow(request.env['warden']).to receive(:authenticate!)
    allow(request.env['warden']).to receive(:user).with(:guest).and_return({})
    allow(request.env['warden']).to receive(:user).with(:user).and_return(nil)
    allow(request.env['warden']).to receive(:user).with(:admin).and_return(nil)
  end

  describe 'POST #sign_up' do
    context 'with valid attributes' do
      let(:user) do
        attributes_for(:user,
                       username: 'isac',
                       password: 'newton2000',
                       password_confirmation: 'newton2000')
      end

      render_views

      it 'persists the new user' do
        expect do
          post :sign_up, user: user, format: 'json'
        end.to change(User, :count).by(1)
      end

      it 'render a success message with (201)' do
        post(:sign_up, user: user, format: 'json')
        expect(response).to have_http_status(:created)
      end

      it 'returns the user id' do
        post(:sign_up, user: user, format: 'json')

        result = JSON.parse(response.body)
        expect(result['user']['id']).to be_present
        expect(result['user']['admin']).to eq(false)
      end

      it 'signs up admins' do
        post(:sign_up, user: user.merge(admin: true), format: 'json')

        result = JSON.parse(response.body)
        expect(result['user']['admin']).to eq(true)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_user) do
        attributes_for(:user,
                       username: 'isac',
                       password: 'newton2000',
                       password_confirmation: 'newton')
      end

      it 'does not persist the user' do
        expect do
          post :sign_up, user: invalid_user, format: 'json'
        end.not_to change(User, :count)
      end

      it 'returns error any other case :unprocessable_entity' do
        post(:sign_up, user: invalid_user, format: 'json')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
