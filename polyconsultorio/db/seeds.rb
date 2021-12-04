# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.find_or_create_by(email: 'admin@example.com') do |user|
    user.password = 'password'
    user.role = :admin
end
  
User.find_or_create_by(email: 'consultant@example.com') do |user|
    user.password = 'password'
    user.role = :consultant
end

User.find_or_create_by(email: 'assistant@example.com') do |user|
    user.password = 'password'
    user.role = :assistant
end
