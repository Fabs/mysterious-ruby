require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:token) }
  end
end
