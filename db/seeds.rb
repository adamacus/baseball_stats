# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

loader = DataLoader.new

player_file = Rails.root.join('db', 'Master-small.csv')
batting_file = Rails.root.join('db', 'Batting-07-12.csv')

loader.load_data(File.open(player_file).read, File.open(batting_file).read)

