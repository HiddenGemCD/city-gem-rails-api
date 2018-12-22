# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Post(id: integer, name: string, description: string, user_id: integer, city_id: integer, created_at: datetime, updated_at: datetime)
# irb(main):004:0>

# require 'faker'

# (0...10).each do
#     user = User.new(name: Faker::Name.name)
#     city = City.new(name: Faker::Address.city)
#     Post.create!(name: Faker::Food.dish, description: Faker::Food.description, city: city, user: user )
# end

CITIES = ['北京','上海','广州','深圳','武汉','西安','杭州','南京','成都','重庆','东莞','大连','沈阳','苏州','昆明','长沙','合肥','宁波','郑州','天津','青岛','济南','哈尔滨','长春','福州','广东省','江苏省','浙江省','四川省','海南省','福建省','山东省','江西省','广西','安徽省','河北省','河南省','湖北省','湖南省','陕西省','山西省','黑龙江省','辽宁省','吉林省','云南省','贵州省','甘肃省','内蒙古','宁夏','西藏','新疆','青海省','香港','澳门']

CITIES.each do |city|
    City.create!(name: city)
end

