FactoryGirl.define do
  factory :score do |f|
    sequence(:value) { |n| n % 5 }
    f.association :user
    f.association :image
  end
end
