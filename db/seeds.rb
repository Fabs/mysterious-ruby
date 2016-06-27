# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all
Image.destroy_all
Score.destroy_all
Session.destroy_all

%w(admin user).each do |role|
  User.create!(username: role, password: role+'12345',
               password_confirmation: role+'12345',
               admin: role == 'admin')
end

robot_hash = Proc.new {|i| "https://robohash.org/#{i}"}
3.times do |i|
  Image.create!(url: robot_hash.call(i), user: User.last)
end

random_score = Proc.new { (0..4).to_a.shuffle.first }
User.all.each do |user|
  Image.all.each do |image|
    Score.create!(user: user, image: image, value: random_score.call)
  end
end