class User < ActiveRecord::Base
  has_secure_password

  validates :username, :password, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true
end
