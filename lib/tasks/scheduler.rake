task :checkins => :environment do
  puts "checkins"
  Stop.check_in_all
  puts "done."
end

