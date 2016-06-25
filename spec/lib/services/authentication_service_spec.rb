require 'rails_helper'

RSpec.describe AuthenticationService do
  before(:each) do
    @user = create(:user)
    @user_credentials = {'username' => @user.username, 'password' => @user.password}
    SessionMock = double()
    SecureRandomMock = double()
  end

  describe 'session creation' do
    context 'with valid credentials' do
      it 'creates a session with a strong token' do
        auth = AuthenticationService.new(SessionMock, SecureRandomMock)

        SecureRandomMock.should_receive(:base64) do |size|
          expect(size).to eq(32)
          'ThisIsASecretToken'
        end

        SessionMock.should_receive(:create) do |options|
          expect(options[:user]).to eq(@user)
          expect(options[:token]).to eq('ThisIsASecretToken')
          Session.create(options)
        end

        session = auth.authenticate(@user_credentials)
        expect(session).to be_persisted
      end
    end

    # TODO: Improve on raise_error
    context 'with invalid credentials' do
      it 'fails with an error when it does not find the user' do
        invalid_credentials = {username: 'inexistent', pasword: 'nothing'}
        auth = AuthenticationService.new(SessionMock, SecureRandomMock)
        expect { auth.authenticate(invalid_credentials) }.to raise_error
      end

      it 'fails with an error when password does not match' do
        invalid_credentials = {username: @user.username, pasword: 'nothing'}
        auth = AuthenticationService.new(Session, SecureRandom)
        expect { auth.authenticate(invalid_credentials) }.to raise_error
      end
    end
  end

  describe 'session termination' do

  end
end
