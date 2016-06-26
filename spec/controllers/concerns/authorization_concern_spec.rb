require 'rails_helper'

RSpec.describe AuthorizationConcern do
  before(:all) do
    class TestController < Api::ApiController
      include AuthorizationConcern
    end
  end

  describe '#is_owner' do
    let(:controller) { TestController.new }
    let(:admin) { create(:user, admin: true) }
    let(:user) { create(:user) }

    let(:user_object) { OpenStruct.new(user_id: user.id) }
    let(:admin_object) { OpenStruct.new(user_id: admin.id) }

    context 'admin' do
      it { expect(controller.is_owner(admin, admin_object)).to eq(true) }
      it { expect(controller.is_owner(admin, user_object)).to eq(true) }
    end

    context 'user' do
      it { expect(controller.is_owner(user, admin_object)).to eq(false) }
      it { expect(controller.is_owner(user, user_object)).to eq(true) }
    end

    context 'missing user or user.id' do
      it { expect(controller.is_owner(nil, admin_object)).to eq(false) }
      it { expect(controller.is_owner(nil, user_object)).to eq(false) }

      it { expect(controller.is_owner({}, admin_object)).to eq(false) }
      it { expect(controller.is_owner({}, user_object)).to eq(false) }
    end

    context 'missing object or object.user_id' do
      context 'user' do
        it { expect(controller.is_owner(user, {})).to eq(true) }
        it { expect(controller.is_owner(user, nil)).to eq(false) }
      end

      context 'admin' do
        it { expect(controller.is_owner(admin, {})).to eq(true) }
        it { expect(controller.is_owner(admin, nil)).to eq(false) }
      end
    end

    context 'missing both' do
      it { expect(controller.is_owner(nil, nil)).to eq(false) }
    end
  end
end
