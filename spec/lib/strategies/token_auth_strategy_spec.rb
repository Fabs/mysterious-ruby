require 'rails_helper'

RSpec.describe TokenAuthStrategy do
  let(:valid_token) do
    { 'HTTP_X_USER_TOKEN' => 'token', 'HTTP_X_USER_ID' => '1' }
  end

  let(:invalid_token) do
    { 'HTTP_X_USER_TOKEN' => 'invalid_token', 'HTTP_X_USER_ID' => '1' }
  end

  let(:empty_token) do
    {}
  end

  let(:missing_user) do
    { 'HTTP_X_USER_TOKEN' => 'token' }
  end

  let(:missing_token) do
    { 'HTTP_X_USER_ID' => '1' }
  end

  let(:user) { build(:user) }
  let(:admin) { build(:user, admin: true) }

  describe '.authenticate!' do
    it 'with no token user is guest' do
      session = class_double('Session')
                .as_stubbed_const(transfer_nested_constants: true)

      strategy = described_class.new({})

      expect(session).not_to receive(:find_by)
      expect(strategy).to receive(:success!).with({}, scope: :guest)

      strategy.authenticate!
    end

    it 'with token, user is on user scope' do
      session = class_double('Session')
                .as_stubbed_const(transfer_nested_constants: true)

      strategy = described_class.new(valid_token)

      session_result = OpenStruct.new(user: user)
      expect(session).to receive(:find_by)
        .with(user_id: '1', token: 'token')
        .and_return(session_result)
      expect(strategy).to receive(:success!).with({}, scope: :guest)
      expect(strategy).to receive(:success!).with(user, scope: :user)

      strategy.authenticate!
    end

    it 'with token and admin:true, user is on admin scope' do
      session = class_double('Session')
                .as_stubbed_const(transfer_nested_constants: true)

      strategy = described_class.new(valid_token)

      session_result = OpenStruct.new(user: admin)
      expect(session).to receive(:find_by)
        .with(user_id: '1', token: 'token')
        .and_return(session_result)
      expect(strategy).to receive(:success!).with({}, scope: :guest)
      expect(strategy).to receive(:success!).with(admin, scope: :user)
      expect(strategy).to receive(:success!).with(admin, scope: :admin)

      strategy.authenticate!
    end

    it 'fail! with invalid token' do
      session = class_double('Session')
                .as_stubbed_const(transfer_nested_constants: true)

      strategy = described_class.new(invalid_token)

      expect(session).to receive(:find_by)
        .with(user_id: '1', token: 'invalid_token')
        .and_return(nil)
      expect(strategy).to receive(:fail!)

      strategy.authenticate!
    end
  end

  describe '.valid?' do
    it { expect(described_class.new(valid_token)).to be_valid}

    it { expect(described_class.new(empty_token)).not_to be_valid}
    it { expect(described_class.new(missing_token)).not_to be_valid}
    it { expect(described_class.new(missing_user)).not_to be_valid}
  end
end
