# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

p '=========================== START ==========================='

p '=========================== CREATE BASEBALL-TEAMS ==========================='

baseball_teams = %W(
  東京ヤクルトスワローズ
  横浜DeNAベースターズ
  阪神タイガース
  読売ジャイアンツ
  広島東洋カープ
  中日ドラゴンズ
  オリックス・バッファローズ
  福岡ソフトバンクフォークス
  埼玉西武ライオンズ
  東北楽天ゴールデンイーグルス
  千葉ロッテマリーンズ
  北海道日本ハムファイターズ
)

BaseballTeam.create!(baseball_teams.map { |name| { name: name } })

p '=========================== CREATE BASEBALL-PARKS ==========================='

baseball_parks = %W(
  明治神宮球場
  横浜スタジアム
  阪神甲子園球場
  東京ドーム
  MAZDA\ Zoom-Zoom\ スタジアム\ 広島
  バンテリンドーム\ ナゴヤ
  京セラドーム
  福岡PayPayドーム
  ベルーナドーム
  楽天生命パーク宮城
  ZOZOマリンスタジアム
  エスコンフィールド\ HOKKAIDO
)

BaseballPark.create!(baseball_parks.map { |name| { name: name } })

p '=========================== CREATE CATEGORIES ==========================='

categories = %W(
  グルメ
  座席からの風景
  あなたのMVP
  その他
)

Category.create!(categories.map { |name| { name: name } })

p '=========================== CREATE USERS ==========================='

5.times do |i|
  User.create(name: "username#{i}", password: "password+#{i}", email: "username#{i}@email.com")
end

p '=========================== CREATE POSTS ==========================='

4.times do |i|
  11.times do |j|
    post = Post.create(
      title: "#{j + 1}番目の投稿です。" * 5,
      content: 'テストです。' * 50,
      user_id: i,
      baseball_team_id: (j + 1),
      baseball_park_id: (j + 1),
      category_id: (i + 1)
    )
    file_name = "image#{i * 11 + j + 1}.jpg"
    file_path = Rails.root.join('app', 'assets', 'images', 'baseball-park-dummy-data.jpg')
    post.photo.attach(io: File.open(file_path), filename: 'baseball-park-dummy-data.jpg', content_type: 'image/jpeg')
  end
end

p '=========================== CREATE GAMES ==========================='

4.times do |i|
  10.times do |j|
    post = Game.create(
      date: "2023-05-#{j + 1}",
      memo: "#{j + 1}番目の投稿です。" * 5,
      home_team_id: (j + 1),
      away_team_id: (j + 2),
      baseball_park_id: (j + 1),
      user_id: (i + 1)
    )
  end
end

p '=========================== END ==========================='
