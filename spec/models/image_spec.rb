require 'rails_helper'

RSpec.describe Image, type: :model do
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:url) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:scores) }

  it { expect(build(:image)).to be_valid }
  it { expect(create(:image)).to be_persisted }
end
