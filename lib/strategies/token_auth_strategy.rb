class TokenAuthStrategy < ::Warden::Strategies::Base
  TOKEN = 'HTTP_X_USER_TOKEN'.freeze
  USER_ID = 'HTTP_X_USER_ID'.freeze

  def valid?
    token_and_user?
  end

  def authenticate!
    success!({}, scope: :guest)
    return unless token_and_user?

    token = env[TOKEN]
    user_id = env[USER_ID]
    session = Session.find_by(user_id: user_id, token: token)
    return fail!('invalid token') unless session

    success!(session.user, scope: :user)
    success!(session.user, scope: :admin) if session.user.admin?
  end

  private

  def token_and_user?
    env.key?(TOKEN) && env.key?(USER_ID)
  end
end
