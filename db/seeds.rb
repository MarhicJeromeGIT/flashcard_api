# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Card.delete_all
User.delete_all

# Create some default cards
5.times do
  r1 = rand(100)
  r2 = rand(100)
  Card.create(
    question: "#{r1}x#{r2}?",
    answer: (r1 * r2).to_s
  )
end

User.create(token: 'abcd')
User.create(token: '1234')
