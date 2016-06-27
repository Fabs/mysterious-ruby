class TokenAuthStrategy < ::Warden::Strategies::Base
  TOKEN = 'HTTP_X_USER_TOKEN'.freeze
  USER_ID = 'HTTP_X_USER_ID'.freeze

  def valid?
    valid = token_and_user?
    if valid
      log_info("Token AUTH #{env['PATH_INFO']}")
    else
      log_info("Token SKIP #{env['PATH_INFO']}")
    end
    valid
  end

  def authenticate!
    grant({}, :guest)
    return unless token_and_user?

    session = find_session
    unless session
      log_info('Token FAIL')
      return fail!('invalid token')
    end

    grant(session.user, :user)
    grant(session.user, :admin) if session.user.admin?
  end

  private

  def grant(user, scope)
    log_info("Token GRANT #{scope}")
    env['warden'].set_user(user, scope: scope)
    success!(user, scope: scope)
  end

  def token_and_user?
    env.key?(TOKEN) && env.key?(USER_ID)
  end

  def log_info(message)
    Rails.logger.info(message)
  end

  def find_session
    Session.find_by(user_id: env[USER_ID], token: env[TOKEN])
  end
end
