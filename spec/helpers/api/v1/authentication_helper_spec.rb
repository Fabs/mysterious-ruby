require 'rails_helper'

RSpec.describe Api::V1::AuthenticationHelper do
  include Api::V1::AuthenticationHelper

  describe 'without user' do
    before(:each) do
      warden = double
      allow(warden).to receive(:user).with(:guest).and_return({})
      allow(warden).to receive(:user).with(:user).and_return(nil)
      allow(warden).to receive(:user).with(:admin).and_return(nil)

      allow(self).to receive(:warden).and_return(warden)
    end

    it { expect(current_user).to eq(nil) }
    it { expect(current_role).to eq(:guest) }
  end

  describe 'with user' do
    let(:user) { create(:user) }
    before(:each) do
      warden = double
      allow(warden).to receive(:user).with(:guest).and_return(user)
      allow(warden).to receive(:user).with(:user).and_return(user)
      allow(warden).to receive(:user).with(:admin).and_return(nil)

      allow(self).to receive(:warden).and_return(warden)
    end

    it { expect(current_user).to eq(user) }
    it { expect(current_role).to eq(:user) }
  end

  describe 'with admin' do
    let(:user) { create(:user, admin: true) }
    before(:each) do
      warden = double
      allow(warden).to receive(:user).with(:guest).and_return(user)
      allow(warden).to receive(:user).with(:user).and_return(user)
      allow(warden).to receive(:user).with(:admin).and_return(user)

      allow(self).to receive(:warden).and_return(warden)
    end

    it { expect(current_user).to eq(user) }
    it { expect(current_role).to eq(:admin) }
  end

  describe 'without warden values' do
    let(:user) { create(:user, admin: true) }
    before(:each) do
      warden = double
      allow(warden).to receive(:user).and_return(nil)

      allow(self).to receive(:warden).and_return(warden)
    end

    it { expect(current_user).to eq(nil) }
    it { expect(current_role).to eq(nil) }
  end
end
