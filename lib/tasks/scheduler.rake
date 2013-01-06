task :checkins => :environment do
  puts "checkins"
  Stops.check_in_all
  puts "done."
end

