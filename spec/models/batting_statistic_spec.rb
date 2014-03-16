require 'spec_helper'

describe BattingStatistic do

    it { should have_db_column(:player_id).of_type(:integer) }
    it { should have_db_column(:at_bats).of_type(:integer) }
    it { should have_db_column(:hits).of_type(:integer) }
    it { should have_db_column(:doubles).of_type(:integer) }
    it { should have_db_column(:triples).of_type(:integer) }
    it { should have_db_column(:home_runs).of_type(:integer) }
    it { should have_db_column(:runs_batted_in).of_type(:integer) }
    it { should have_db_column(:year).of_type(:integer) }
    it { should have_db_column(:league).of_type(:text) }
    it { should have_db_column(:team).of_type(:text) }

    it { should belong_to(:player) }

    it { should have_readonly_attribute(:player_id) }
    it { should have_readonly_attribute(:at_bats) }
    it { should have_readonly_attribute(:hits) }
    it { should have_readonly_attribute(:doubles) }
    it { should have_readonly_attribute(:triples) }
    it { should have_readonly_attribute(:home_runs) }
    it { should have_readonly_attribute(:runs_batted_in) }
    it { should have_readonly_attribute(:year) }
    it { should have_readonly_attribute(:league) }
    it { should have_readonly_attribute(:team) }

    describe '.most_improved_batting_avg' do
      let(:player_1) { FactoryGirl.create(:player) }
      let(:player_2) { FactoryGirl.create(:player) }

      let(:p1_2010_at_bats) { 200 }

      let(:statistics) do
        [
          FactoryGirl.create(:batting_statistic, player: player_1, year: 2009, at_bats: 200, hits: 10),
          FactoryGirl.create(:batting_statistic, player: player_1, year: 2010, at_bats: p1_2010_at_bats, hits: 20),
          FactoryGirl.create(:batting_statistic, player: player_2, year: 2009, at_bats: 200, hits: 10),
          FactoryGirl.create(:batting_statistic, player: player_2, year: 2010, at_bats: 200, hits: 19)
        ]
      end

      before { statistics.each { |s| s.save } }

      it 'should return the player with the greatest improvement' do
        expect(BattingStatistic.most_improved_batting_avg(2010)).to eq(player_1)
      end

      context 'when a player does not have 200 at_bats' do
        let(:p1_2010_at_bats) { 199 }
        it 'should ignore that players statistics' do
          expect(BattingStatistic.most_improved_batting_avg(2010)).to eq(player_2)
        end
      end

      context 'when a player with no first year statistics exists' do
        before { FactoryGirl.create(:batting_statistic, year: 2010, at_bats: 200, hits: 200) }
        it 'should ignore that player' do
          expect(BattingStatistic.most_improved_batting_avg(2010)).to eq(player_1)
        end
      end

      context 'when a player with no second year statistics exists' do
        before { FactoryGirl.create(:batting_statistic, year: 2009, at_bats: 200, hits: 200) }
        it 'should ignore that player' do
          expect(BattingStatistic.most_improved_batting_avg(2010)).to eq(player_1)
        end
      end
    end

    describe '.triple_crown_winner' do
      let(:player_1) { FactoryGirl.create(:player) }
      let(:player_2) { FactoryGirl.create(:player) }
      let(:player_3) { FactoryGirl.create(:player) }

      let(:player_1_at_bats) { 400 }
      let(:player_1_year) { 2009 }
      let(:player_1_league) { 'NL' }
      let(:player_1_hits) { 400 }
      let(:player_1_home_runs) { 100 }
      let(:player_1_rbis) { 101 }

      let(:statistics) do
        [
          FactoryGirl.build(:batting_statistic,
            player: player_1,
            year: player_1_year,
            league: player_1_league,
            at_bats: player_1_at_bats,
            hits: player_1_hits,
            home_runs: player_1_home_runs,
            runs_batted_in: player_1_rbis
          ),
          FactoryGirl.build(:batting_statistic,
            player: player_2,
            year: 2009,
            league: 'NL',
            at_bats: 400,
            hits: 399,
            home_runs: 99,
            runs_batted_in: 99
          ),
          FactoryGirl.build(:batting_statistic,
            player: player_3,
            year: 2009,
            league: 'NL',
            at_bats: 400,
            hits: 398,
            home_runs: 98,
            runs_batted_in: 100
          )
        ]
      end

      before { statistics.each { |s| s.save } }

      it 'should return a player who has the highest batting average, most home runs, and most RBIs' do
        expect(BattingStatistic.triple_crown_winner(2009, 'NL')).to eq(player_1)
      end

      context 'when a player has less than 400 at bats' do
        let(:player_1_at_bats) { 399 }
        it 'should ignore that player' do
          expect(BattingStatistic.triple_crown_winner(2009, 'NL')).to be_nil
        end
      end

      context 'when a player is not in the requested year' do
        let(:player_1_year) { 2010 }
        it 'should ignore that player' do
          expect(BattingStatistic.triple_crown_winner(2009, 'NL')).to be_nil
        end
      end

      context 'when a player is not in the requested league' do
        let(:player_1_league) { 'AL' }
        it 'should ignore that player' do
          expect(BattingStatistic.triple_crown_winner(2009, 'NL')).to be_nil
        end
      end

      context 'when a player does not have the highest batting average' do
        let(:player_1_hits) { 300 }
        it 'should ignore that player' do
          expect(BattingStatistic.triple_crown_winner(2009, 'NL')).to be_nil
        end
      end

      context 'when a player does not have the most home runs' do
        let(:player_1_home_runs) { 50 }
        it 'should ignore that player' do
          expect(BattingStatistic.triple_crown_winner(2009, 'NL')).to be_nil
        end
      end

      context 'when a player does not have the most rbis' do
        let(:player_1_rbis) { 50 }
        it 'should ignore that player' do
          expect(BattingStatistic.triple_crown_winner(2009, 'NL')).to be_nil
        end
      end

    end

    describe '#slugging_percentage' do

      let(:statistic) do
        FactoryGirl.build(:batting_statistic,
          hits: 8,
          doubles: 3,
          triples: 2,
          home_runs: 2,
          at_bats: 10
        )
      end

      it 'should calculate slugging percentage based on the statistcs' do
        statistic.slugging_percentage.should == 2.1
      end

      it 'should return 0 when there are no at bats' do
        statistic.at_bats = 0
        statistic.slugging_percentage.should == 0
      end

      it 'should count null values as 0' do
        statistic = FactoryGirl.build(:batting_statistic, hits: nil, doubles: nil, triples: nil, home_runs: nil, at_bats: nil)
        statistic.slugging_percentage.should == 0
      end

    end

    describe '#batting_average' do

      let(:statistic) { FactoryGirl.build(:batting_statistic, hits: 100, at_bats: 400)}
      it 'should calculate the batting average based on the statistic' do
        statistic.batting_average.should == 0.25
      end

      it 'should return 0 when there are no at_bats' do
        statistic.at_bats = 0
        statistic.batting_average.should == 0
      end

    end

end
