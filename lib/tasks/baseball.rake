namespace :baseball do

  desc 'Print out out baseball stats'
  task stats: :environment do
    puts StatPrinter.new.print
  end

end
