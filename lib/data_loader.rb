require 'csv'

class DataLoader

  def load_data player_data, batting_data

    players = {}

    ActiveRecord::Base.transaction do

      CSV.parse(player_data, headers: true) do |row|
        player = Player.create(
          player_id: row['playerID'],
          birth_year: row['birthYear'],
          first_name: row['nameFirst'],
          last_name: row['nameLast']
        )
        players[player.player_id] = player
      end

      CSV.parse(batting_data, headers: true) do |row|
        BattingStatistic.create(
          year: row['yearID'],
          league: row['league'],
          team: row['teamID'],
          at_bats: row['AB'],
          hits: row['H'],
          doubles: row['2B'],
          triples: row['3B'],
          home_runs: row['HR'],
          runs_batted_in: row['RBI'],
          player: players[row['playerID']]
        )
      end
    end

  end


end