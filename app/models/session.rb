class Session < ActiveRecord::Base
  belongs_to :user

  validates :token, :user, presence: true
end
