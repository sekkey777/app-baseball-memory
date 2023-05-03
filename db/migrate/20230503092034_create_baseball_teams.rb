class CreateBaseballTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :baseball_teams do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
