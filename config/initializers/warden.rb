require Rails.root.join('lib/strategies/token_auth_strategy')

Warden::Strategies.add(:token_auth, TokenAuthStrategy)
