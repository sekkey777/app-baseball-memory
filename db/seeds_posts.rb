# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

p '=========================== START ==========================='

p '=========================== CREATE POSTS ==========================='

demo_data = eval(File.read(Rails.root.join('db/demo/demo_post_data.rb')))

demo_data.each do |data|
  Post.create(
    title: data[:title],
    content: data[:content],
    baseball_team: BaseballTeam.all.sample,
    baseball_park: BaseballPark.all.sample,
    category: Category.find(1),
    user: User.all.sample,
    photo: Rack::Test::UploadedFile.new(Rails.root.join('app', 'assets', 'images', 'baseball-park-dummy-data.jpg'), 'image/jpeg'),
  )
end

p '=========================== END ==========================='
