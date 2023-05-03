class CreateBaseballParks < ActiveRecord::Migration[6.1]
  def change
    create_table :baseball_parks do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
