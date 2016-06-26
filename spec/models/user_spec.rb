require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_inclusion_of(:admin).in_array([true, false]) }

    context 'new user' do
      it 'is valid with username and password' do
        expect(build(:user)).to be_valid
      end

      it 'is invalid without username and password' do
        user = build(:user, username: nil, password: nil)
        user.valid?
        expect(user.errors[:username]).to include("can't be blank")
        expect(user.errors[:password]).to include("can't be blank")
      end

      it 'is invalid with a password with less than 8 characters' do
        user = build(:user, password: 'short', password_confirmation: 'short')
        user.valid?

        error = 'is too short (minimum is 8 characters)'
        expect(user.errors[:password]).to include(error)
      end

      it 'is invalid without password_confirmation' do
        user = build(:user, password: 'valid_password',
                            password_confirmation: '')
        user.valid?

        error = "doesn't match Password"
        expect(user.errors[:password_confirmation]).to include(error)
      end

      it 'is invalid to create an user with a duplicate name' do
        user1 = create(:user)
        user2 = build(:user, username: user1.username)
        user2.valid?
        expect(user2.errors[:username]).to include('has already been taken')
      end
    end

    context 'existing user' do
      it 'should save existing user without touching password' do
        user = create(:user)
        expect(user.save).to be(true)
      end

      it 'should save user changing username' do
        user = create(:user)
        user.username = 'Wallie'
        expect(user.save).to be(true)
      end
    end
  end
end
