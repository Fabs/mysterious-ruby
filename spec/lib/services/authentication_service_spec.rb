require 'rails_helper'

RSpec.describe AuthenticationService do
  # TODO: Refactor to use let
  before(:each) do
    @user = create(:user)
    @user_credentials = { 'username' => @user.username,
                          'password' => @user.password }
    @session_mock = double(Session)
    @secure_random_mock = double(SecureRandom)
    @user_mock = double(User)
  end

  describe 'session creation' do
    context 'with valid credentials' do
      it 'creates a session with a strong token' do
        auth = AuthenticationService.new(@user_mock, @session_mock,
                                         @secure_random_mock)

        @user_mock.should_receive(:find_by) do |options|
          expect(options[:username]).to eq(@user.username)
          user = double(@user)
          allow(user).to receive(:authenticate).and_return(true)
          allow(user).to receive(:id).and_return(@user.id)
          user
        end

        @secure_random_mock.should_receive(:base64) do |size|
          expect(size).to eq(32)
          'ThisIsASecretToken'
        end

        @session_mock.should_receive(:create) do |options|
          expect(options[:user].id).to eq(@user.id)
          expect(options[:token]).to eq('ThisIsASecretToken')
        end

        auth.authenticate(@user_credentials)
      end
    end

    # TODO: Improve on raise_error
    context 'with invalid credentials' do
      it 'fails with an error when it does not find the user' do
        invalid_credentials = { 'username' => 'inexistent',
                                'pasword' => 'nothing' }
        auth = AuthenticationService.new(User, @session_mock,
                                         @secure_random_mock)
        @session_mock.should_not_receive(:create)

        auth.authenticate(invalid_credentials)
      end

      it 'fails with an error when password does not match' do
        invalid_credentials = { 'username' => @user.username,
                                'pasword' => 'nothing' }
        auth = AuthenticationService.new(User, @session_mock, SecureRandom)
        @session_mock.should_not_receive(:create)

        auth.authenticate(invalid_credentials)
      end
    end
  end

  describe 'session termination' do
    before(:each) do
      @session = create(:session)
      @session_credentials = { token: @session.token,
                               user_id: @session.user.id }
    end

    it 'destroy sessions upon sign_off with valid credentials' do
      auth = AuthenticationService.new(@user_mock, @session_mock,
                                       @secure_random_mock)

      @session_mock.should_receive(:find_by) do |options|
        expect(options[:token]).to eq(@session.token)
        expect(options[:user_id]).to eq(@session.user.id)

        session = double
        session.should_receive(:destroy)
        session
      end

      auth.sign_off(@session_credentials)
    end

    it 'does nothing with invalid credentials' do
      auth = AuthenticationService.new(@user_mock, @session_mock,
                                       @secure_random_mock)

      @session_mock.should_receive(:find_by)
      @session_mock.should_not_receive(:destroy)
      auth.sign_off(@session_credentials)
    end
  end
end
