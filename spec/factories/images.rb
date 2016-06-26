FactoryGirl.define do
  factory :image do |f|
    sequence(:url) { |n| "http://google.com/1.#{n}" }
    f.association :user
  end
end
