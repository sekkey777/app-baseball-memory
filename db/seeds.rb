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

p '=========================== END ==========================='
