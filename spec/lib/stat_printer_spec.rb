require 'spec_helper'

describe StatPrinter do

  let(:printer) { StatPrinter.new }
  let(:players) { [] }
  let(:batting_statistics) { [] }

  describe '#print' do

    before do
      batting_statistics.each{ |s| s.save }
    end

    subject { printer.print.split("\n") }

    its(:count)  { should == 6 }
    its(:first)  { should == "Most Improved Batting Average from 2009 - 2010: " }
    its(:second) { should == "Slugging percentage for all players on the Oakland A's in 2007: " }
    its(:third)  { should == "AL triple crown winner for 2011: (No winner)" }
    its(:fourth) { should == "NL triple crown winner for 2011: (No winner)" }
    its(:fifth)  { should == "AL triple crown winner for 2012: (No winner)" }
    its([5])     { should == "NL triple crown winner for 2012: (No winner)" }

    context 'when there is batting and player data' do

      let(:players) do
        [
          FactoryGirl.build(:player, first_name: 'Bob', last_name: 'Marley'),
          FactoryGirl.build(:player, first_name: 'Don', last_name: 'Johnson')
        ]
      end

      let(:batting_statistics) do
        [
          FactoryGirl.build(:batting_statistic, player: players[0], team: 'OAK', year: 2007),
          FactoryGirl.build(:batting_statistic, player: players[1], team: 'OAK', year: 2007),
          FactoryGirl.build(:batting_statistic, player: players[0], year: 2009, at_bats: 400, hits: 400),
          FactoryGirl.build(:batting_statistic, player: players[1], year: 2009, at_bats: 400, hits: 200),
          FactoryGirl.build(:batting_statistic, player: players[0], year: 2010, at_bats: 400, hits: 200),
          FactoryGirl.build(:batting_statistic, player: players[1], year: 2010, at_bats: 400, hits: 300),
          FactoryGirl.build(:batting_statistic, player: players[0], year: 2011, league: 'AL', at_bats: 400, hits: 400, runs_batted_in: 300, home_runs: 300),
          FactoryGirl.build(:batting_statistic, player: players[1], year: 2011, league: 'AL', at_bats: 400, hits: 300, runs_batted_in: 299, home_runs: 299),
        ]
      end

      its(:first)  { should == "Most Improved Batting Average from 2009 - 2010: Don Johnson"}
      its(:second) { should == "Slugging percentage for all players on the Oakland A's in 2007: " }
      its(:third)  { should == "  Bob Marley           #{'%.3f' % batting_statistics[0].slugging_percentage}" }
      its(:fourth) { should == "  Don Johnson          #{'%.3f' % batting_statistics[1].slugging_percentage}" }
      its(:fifth)  { should == "AL triple crown winner for 2011: Bob Marley" }
      its([5])     { should == "NL triple crown winner for 2011: (No winner)" }
      its([6])     { should == "AL triple crown winner for 2012: (No winner)" }
      its([7])     { should == "NL triple crown winner for 2012: (No winner)" }

    end
  end
end