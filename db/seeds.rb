# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.find(1)
# user.gakutikas.create!(title: '塾生新聞会での新聞配布', content: '新聞を2月に配布');
user.gakutikas.create!(title: '塾生新聞会での新聞配布2', content: '新聞を2月に配布');
user.gakutikas.create!(title: '塾生新聞会での新聞配布3', content: '新聞を2月に配布');
user.gakutikas.create!(title: '塾生新聞会での新聞配布4', content: '新聞を2月に配布');