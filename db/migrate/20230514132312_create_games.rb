class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.datetime :date, null: false
      t.text :memo, null: false
      t.string :photo
      t.references :home_team, foreign_key: { to_table: :baseball_teams }, null: false
      t.references :away_team, foreign_key: { to_table: :baseball_teams }, null: false
      t.references :baseball_park, foreign_key: { to_table: :baseball_parks }, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
