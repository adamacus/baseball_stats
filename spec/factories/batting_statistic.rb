FactoryGirl.define do
  factory :batting_statistic do
    player
    at_bats        { Faker::Number.number 2 }
    hits           { Faker::Number.number 2 }
    doubles        { Faker::Number.number 2 }
    triples        { Faker::Number.number 2 }
    home_runs      { Faker::Number.number 2 }
    runs_batted_in { Faker::Number.number 2 }
    year           { rand(1900..1995) }
    league         { ['AL', 'NL'].sample }
    team           { "#{Faker::Commerce.color.capitalize} Team" }
  end
end
