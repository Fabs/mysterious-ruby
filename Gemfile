source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '4.2.6'
gem 'pg'
gem 'puma'

# TODO: Maybe I do not need those either
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bcrypt', '~> 3.1.7'

gem 'rails-api'
gem 'responders'
gem 'apipie-rails'
gem 'warden'

group :development, :test do
  gem 'rspec-rails', '~> 3.4'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers', '~> 3.1'

  gem 'rubocop', require: false

  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'

  gem 'byebug'
  gem "codeclimate-test-reporter", require: nil
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end
