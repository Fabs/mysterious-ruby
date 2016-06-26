FactoryGirl.define do
  factory :user do
    sequence(:username) { |i| "Armstrong#{i}" }
    password 'neil1930'
    password_confirmation 'neil1930'
    admin false
  end
end
