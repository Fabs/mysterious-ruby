class Score < ActiveRecord::Base
  belongs_to :user
  belongs_to :image

  validates :user, :image, :value, presence: true
  validates_inclusion_of :value, in: 0..4
end
