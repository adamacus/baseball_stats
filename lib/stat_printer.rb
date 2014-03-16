class StatPrinter

  def print
    "Most Improved Batting Average from 2009 - 2010: #{most_improved}\n"+
    "Slugging percentage for all players on the Oakland A's in 2007: \n"+
    slugging_percentages +
    "AL triple crown winner for 2011: #{triple_crown_winner(2011, 'AL')}\n"+
    "NL triple crown winner for 2011: #{triple_crown_winner(2011, 'NL')}\n"+
    "AL triple crown winner for 2012: #{triple_crown_winner(2012, 'AL')}\n"+
    "NL triple crown winner for 2012: #{triple_crown_winner(2012, 'NL')}"
  end

  private

    def most_improved
      improved = BattingStatistic.most_improved_batting_avg(2010)
      improved.nil? ? '' : improved.full_name
    end

    def slugging_percentages
      BattingStatistic.where(team: 'OAK', year: 2007).map do |s|
        "  %-20s %.3f\n" % [s.player.full_name, s.slugging_percentage]
      end.join
    end

    def triple_crown_winner year, league
      winner = BattingStatistic.triple_crown_winner year, league
      winner.nil? ? "(No winner)" : winner.full_name
    end
end