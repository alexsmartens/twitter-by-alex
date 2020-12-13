# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a main sample users
User.create!(
  name: "Alex M",
  email: "alex@example.com",
  password: "123456",
  password_confirmation: "123456",
  activated: true,
  activated_at: Time.zone.now,
)
User.create!(
  name: "Example User",
  email: "example@railstutorial.org",
  password: "123456",
  password_confirmation: "123456",
  activated: true,
  activated_at: Time.zone.now,
)

# Generate a bunch of additional users
98.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"

  # 'create!' method is just like the 'create' method, except it raises an
  # exception if user validation fails rather than returning false
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now,
   )
end

# Generate microposts
users = User.order(:created_at).take(6)
50.times do |n|
  if n < 49 && rand < 0.8
    content = Faker::Lorem.sentence(word_count: 3 + (n/5).to_i )
  else
    content = Faker::ChuckNorris.fact
  end
  users.each { |user| user.microposts.create!(content: content) }
end

# Create following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
