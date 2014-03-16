class CreateBattingStatistics < ActiveRecord::Migration
  def change
    create_table :batting_statistics do |t|
      t.integer :player_id
      t.integer :at_bats
      t.integer :hits
      t.integer :doubles
      t.integer :triples
      t.integer :home_runs
      t.integer :runs_batted_in
      t.integer :year
      t.text :league
      t.text :team

      t.timestamps
    end
  end
end
