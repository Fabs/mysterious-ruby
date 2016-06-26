require 'rails_helper'

RSpec.describe Score, type: :model do
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:image) }
  it { is_expected.to validate_presence_of(:value) }

  it { is_expected.to validate_inclusion_of(:value).in_range(0..4) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:image) }

  it { expect(build(:score)).to be_valid }
  it { expect(create(:score)).to be_persisted }
end
