require 'rails_helper'

RSpec.describe AuthenticationConcern do
  before do
    class TestController < Api::ApiController
      include AuthenticationConcern
    end
  end

  describe 'without user' do
    before(:each) do
      warden = double
      allow(warden).to receive(:user).with(:guest).and_return({})
      allow(warden).to receive(:user).with(:user).and_return(nil)
      allow(warden).to receive(:user).with(:admin).and_return(nil)

      @test_controller = TestController.new
      allow(@test_controller).to receive(:warden).and_return(warden)
    end

    it { expect(@test_controller.current_user).to eq(nil) }
    it { expect(@test_controller.current_role).to eq(:guest) }
  end

  describe 'with user' do
    let(:user) { create(:user) }
    before(:each) do
      warden = double
      allow(warden).to receive(:user).with(:guest).and_return(user)
      allow(warden).to receive(:user).with(:user).and_return(user)
      allow(warden).to receive(:user).with(:admin).and_return(nil)

      @test_controller = TestController.new
      allow(@test_controller).to receive(:warden).and_return(warden)
    end

    it { expect(@test_controller.current_user).to eq(user) }
    it { expect(@test_controller.current_role).to eq(:user) }
  end

  describe 'with admin' do
    let(:user) { create(:user, admin: true) }
    before(:each) do
      warden = double
      allow(warden).to receive(:user).with(:guest).and_return(user)
      allow(warden).to receive(:user).with(:user).and_return(user)
      allow(warden).to receive(:user).with(:admin).and_return(user)

      @test_controller = TestController.new
      allow(@test_controller).to receive(:warden).and_return(warden)
    end

    it { expect(@test_controller.current_user).to eq(user) }
    it { expect(@test_controller.current_role).to eq(:admin) }
  end

  describe 'without warden values' do
    let(:user) { create(:user, admin: true) }
    before(:each) do
      warden = double
      allow(warden).to receive(:user).and_return(nil)

      @test_controller = TestController.new
      allow(@test_controller).to receive(:warden).and_return(warden)
    end

    it { expect(@test_controller.current_user).to eq(nil) }
    it { expect(@test_controller.current_role).to eq(nil) }
  end
end
