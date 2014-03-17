require 'csv'

class DataLoader

  def load_data player_data, batting_data

    players = {}

    ActiveRecord::Base.transaction do

      print '-- Importing player data '

      idx = 0
      CSV.parse(player_data, headers: true) do |row|
        player = Player.create(
          player_id: row['playerID'],
          birth_year: row['birthYear'],
          first_name: row['nameFirst'],
          last_name: row['nameLast']
        )
        players[player.player_id] = player
        print '.' if idx % 1000 == 0
        idx = idx+  1
      end

      print "done. \n-- Importing batting data "
      idx = 0

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
        print '.' if idx % 1000 == 0
        idx = idx+1
      end

      puts "done.\n"
    end

  end


end