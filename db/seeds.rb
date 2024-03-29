# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'securerandom'

def generate_random_password(length=10)
  SecureRandom.alphanumeric(length)
end


# Create a main sample users
password1 = generate_random_password()
User.create!(
  name: "Alex M",
  email: "alex@example.com",
  password: password1,
  password_confirmation: password1,
  activated: true,
  activated_at: Time.zone.now,
)
password2 = generate_random_password()
User.create!(
  name: "Example User",
  email: "example@railstutorial.org",
  password: password2,
  password_confirmation: password2,
  activated: true,
  activated_at: Time.zone.now,
)

# Generate a bunch of additional users
98.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = generate_random_password()

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
