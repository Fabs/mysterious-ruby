{
  session: {
      token: @session.token,
      user_id: @session.user_id,
      role: @session.user.admin ? 'admin' : 'user'
  }
}.to_json