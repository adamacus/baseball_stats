class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.text :player_id
      t.integer :birth_year
      t.text :first_name
      t.text :last_name

      t.timestamps
    end
  end
end
