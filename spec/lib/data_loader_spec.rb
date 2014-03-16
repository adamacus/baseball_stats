require 'data_loader'

describe DataLoader do

  describe '#load_data' do

    let(:player_data) { '' }
    let(:batting_data) { '' }

    let(:loader) { DataLoader.new }

    context 'when there is no data' do

      let(:player_data) { '' }
      it 'should not load any players' do
        expect{ loader.load_data(player_data, batting_data) }.to_not change{Player.count}
      end

    end

    context 'when the data contains players and batting statistics' do

      let(:player_data) {
        [
          ['playerID','birthYear','nameFirst','nameLast'],
          ['aaronha01','1934','Hank','Aaron'],
          ['aaronto01','1939','Tommie','Aaron']
        ].map{ |r| r.to_csv }.join
      }

      let(:batting_data) {
        [
          ['playerID' ,'yearID','league','teamID','AB','H','2B','3B','HR','RBI'],
          ['aaronha01','1958'  ,'AL'    ,'NYA'   ,'1' ,'2','3' ,'4' ,'5' ,'6'],
          ['aaronha01','1959'  ,'NL'    ,'LAN'   ,'7' ,'8','9' ,'10','11','12']
        ].map{ |r| r.to_csv }.join
      }

      it 'should persist the players' do
        expect{ loader.load_data(player_data, batting_data) }
          .to change{Player.count}.by(2)
      end

      it 'should persist the batting statistics' do
        expect{ loader.load_data(player_data, batting_data) }
          .to change{BattingStatistic.count}.by(2)
      end

      context 'first player data' do
        subject { Player.first }

        its(:player_id)  { should == 'aaronha01' }
        its(:birth_year) { should == 1934 }
        its(:first_name) { should == 'Hank' }
        its(:last_name)  { should == 'Aaron' }
      end

      context 'first batting statistic data' do
        subject { BattingStatistic.first }

        its(:year)           { should == 1958 }
        its(:league)         { should == 'AL' }
        its(:team)           { should == 'NYA' }
        its(:at_bats)        { should == 1 }
        its(:hits)           { should == 2 }
        its(:doubles)        { should == 3 }
        its(:triples)        { should == 4 }
        its(:home_runs)      { should == 5 }
        its(:runs_batted_in) { should == 6 }
        its(:player)         { should == Player.first }

      end

    end

  end

end