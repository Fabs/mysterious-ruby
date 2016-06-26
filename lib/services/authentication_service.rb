class AuthenticationService
  attr_reader :session

  def initialize(user_store, session_store, generator)
    @user_store = user_store
    @session_store = session_store
    @generator = generator
    @custom_errors = {}
  end

  def authenticate(credentials)
    @user = fetch_user(credentials)
    @session = create_session(@user) if @user
  end

  def sign_off(credentials)
    @session = @session_store.find_by(credentials)
    @session.destroy if @session
  end

  # TODO: Add Spec later, when we decided how to show errors
  def errors
    errors = @custom_errors
    errors = errors.merge(user: @user.errors.messages) if @user
    errors = errors.merge(session: @session.errors.messages) if @session

    errors
  end

  private

  def fetch_user(credentials)
    user = @user_store.find_by(username: credentials['username'])
    if !user || !user.try(:authenticate, credentials['password'])
      @custom_errors[:auth] = 'Username and Password combination do not match'
      return
    end

    user
  end

  def create_session(user)
    token = @generator.base64(32)
    @session_store.create(user: user, token: token)
  end
end
