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
  ハイライト
  思い出
  あなたのMVP
  グルメ
  座席からの風景
  その他
)

Category.create!(categories.map { |name| { name: name } })

p '=========================== CREATE USERS ==========================='

# 一般ユーザー
5.times do |i|
  User.create(
    name: "username#{i}",
    password: SecureRandom.urlsafe_base64 + '+1234',
    email: SecureRandom.hex(20) + '@appbaseballmemory.com'
  )
end

# ゲストユーザー
User.create(
  name: 'guest_user',
  password: SecureRandom.urlsafe_base64,
  email: SecureRandom.hex(20) + '@appbaseballmemory.com'
)

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

p '=========================== CREATE GAMES ==========================='

# すでに実施済みの試合
15.times do |i|
  home_team_score = rand(16)
  away_team_score = rand(16)
  date = Time.new(2023, rand(3..6), rand(1..30), 10, 10, 10)
  home_team = BaseballTeam.all.sample
  away_team = BaseballTeam.where.not(id: home_team.id).sample
  
  result = if home_team_score > away_team_score
              'win'
            elsif home_team_score < away_team_score
              'lose'
            else
              'draw'
            end
  
  Game.create(
    date: date,
    memo: "#{date.strftime('%-m月%-d日')}に実施された「#{home_team.name}」対「#{away_team.name}」の試合です。",
    home_team: home_team,
    away_team: away_team,
    baseball_park: BaseballPark.all.sample,
    user: User.find_by(name: 'guest_user'),
    home_team_score: home_team_score,
    away_team_score: away_team_score,
    result: result
  )
end

# 予定されている試合
10.times do |i|
  date = Time.new(2023, rand(7..9), rand(1..30), 10, 10, 10)
  home_team = BaseballTeam.all.sample
  away_team = BaseballTeam.where.not(id: home_team.id).sample
  
  Game.create(
    date: date,
    memo: "#{date.strftime('%-m月%-d日')}に実施予定の「#{home_team.name}」対「#{away_team.name}」の試合です。",
    home_team: home_team,
    away_team: away_team,
    baseball_park: BaseballPark.all.sample,
    user: User.find_by(name: 'guest_user'),
    home_team_score: nil,
    away_team_score: nil,
    result: 'scheduled'
  )
end

p '=========================== END ==========================='

def set_result
  if home_team_score.nil? || away_team_score.nil?
    return self.result = 'scheduled'
  end

  if home_team_score > away_team_score
    self.result = 'win'
  elsif home_team_score < away_team_score
    self.result = 'lose'
  elsif home_team_score == away_team_score
    self.result = 'draw'
  else
    self.result = 'scheduled'
  end
end
