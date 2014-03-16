class BattingStatistic < ActiveRecord::Base

  belongs_to :player

  attr_readonly :player_id,
                :at_bats,
                :hits,
                :doubles,
                :triples,
                :home_runs,
                :runs_batted_in,
                :year,
                :league,
                :team

  def self.most_improved_batting_avg year

    y1 = Hash[BattingStatistic.where('at_bats >= 200 and year=?', year - 1).map { |s|
      [s.player, s.hits.to_f / s.at_bats]
    }]

    y2 = Hash[BattingStatistic.where('at_bats >= 200 and year=?', year).map { |s|
      [s.player, s.hits.to_f / s.at_bats]
    }]

    eligible_players = y2.select { |player_id, rbi| !y1[player_id].nil? }
    if eligible_players.any?
      eligible_players.max_by do |player_id, rbi|
        rbi - y1[player_id].to_i
      end.first
    else
      nil
    end

  end

  def self.triple_crown_winner year, league
    query = 'year = ? and league = ? and at_bats >= 400'
    highest_batting_average = BattingStatistic.where(query, year, league).max_by do |s|
      s.batting_average
    end
    most_home_runs = BattingStatistic.where(query, year, league).order(home_runs: :desc).limit(1)
    most_rbis = BattingStatistic.where(query, year, league).order(runs_batted_in: :desc).limit(1)

    unless highest_batting_average.nil? || most_home_runs.empty? || most_rbis.empty?
      if highest_batting_average.player == most_home_runs.first.player && highest_batting_average.player == most_rbis.first.player
        return highest_batting_average.player
      end
    end
  end

  def slugging_percentage
    return 0 if at_bats == 0 || at_bats.nil?
    ((hits.to_i - doubles.to_i - triples.to_i - home_runs.to_i) + (2.0 * doubles.to_i) + (3.0 * triples.to_i) + (4.0 * home_runs.to_i)) / at_bats.to_i
  end

  def batting_average
    at_bats == 0 ? 0 : hits.to_f / at_bats
  end

end
