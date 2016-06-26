require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:token) }

    it { expect(build(:session)).to be_valid }
    it { expect(create(:session)).to be_persisted }

    it { is_expected.to belong_to(:user) }
  end
end
