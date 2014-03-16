namespace :baseball_stats do

  task :print
    puts StatPrinter.new().print
  end

end