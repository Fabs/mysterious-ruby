class AuthenticationService
  def initialize(session, generator)
    @session = session
    @generator = generator
  end

  def authenticate(credentials)
    user = fetch_user(credentials)
    create_session(user)
  end

  private

  def fetch_user(credentials)
    user = User.find_by(username: credentials['username'])
    raise 'error' unless user.try(:authenticate, credentials['password'])

    user
  end

  def create_session(user)
    token = @generator.base64(32)
    session = @session.create(user: user, token: token)
    raise 'error' unless session

    session
  end
end