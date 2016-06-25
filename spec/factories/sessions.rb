FactoryGirl.define do
  factory :session do |f|
    f.association :user
    f.token 'something_very_secure_and_big'
  end
end
