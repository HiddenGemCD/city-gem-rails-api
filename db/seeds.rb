# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Post(id: integer, name: string, description: string, user_id: integer, city_id: integer, created_at: datetime, updated_at: datetime)
# irb(main):004:0>

require 'faker'

(0...10).each do
    user = User.new(name: Faker::Name.name)
    city = City.new(name: Faker::Address.city)
    Post.create!(name: Faker::Food.dish, description: Faker::Food.description, city: city, user: user )
end