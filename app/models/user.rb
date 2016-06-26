class User < ActiveRecord::Base
  has_secure_password

  validates :username, :password, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  # There is actually 3 states for roles
  # GUEST: when there is no user at all
  # USER: when there is an user admin = FALSE
  # ADMIN: when there is an user admin = TRUE
  validates_inclusion_of :admin, in: [true, false]
end
