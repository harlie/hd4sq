task :checkins => :environment do
  puts "checkins"
  Stop.check_in_all
  puts "done."
end

task :follow_ups => :environment do
  puts "folowups"
  Itinerary.where("created_at > ?", Time.now - 1.day).each do |itin|
    FollowUpMailer::follow_up(itin).deliver
  end
  puts "done."
end


