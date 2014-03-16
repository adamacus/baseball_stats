require 'spec_helper'

describe Player do

  it { should have_db_column(:player_id).of_type(:text) }
  it { should have_db_column(:birth_year).of_type(:integer) }
  it { should have_db_column(:first_name).of_type(:text) }
  it { should have_db_column(:last_name).of_type(:text) }

  it { should have_readonly_attribute(:player_id) }
  it { should have_readonly_attribute(:birth_year) }
  it { should have_readonly_attribute(:first_name) }
  it { should have_readonly_attribute(:last_name) }

  describe '#full_name' do

    it 'should combine first and last name' do
      expect(FactoryGirl.build(:player, first_name: 'Tom', last_name: 'Tomson').full_name).to eq('Tom Tomson')
    end

    it 'should not include a null first name' do
      expect(FactoryGirl.build(:player, first_name: nil, last_name: 'Tomson').full_name).to eq('Tomson')
    end

    it 'should not include a null last name' do
      expect(FactoryGirl.build(:player, first_name: 'Tom', last_name: nil).full_name).to eq('Tom')
    end

  end


end
