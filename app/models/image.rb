class Image < ActiveRecord::Base
  belongs_to :user
  has_many :scores

  validates :url, :user, presence: true
end
