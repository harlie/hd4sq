class Itinerary < ActiveRecord::Base
  has_many :stops
  belongs_to :foursquare_user
  attr_accessible :checkin_id, :foursquare_user_id
  
  def to_s
    sched = ''
    stops.each do |stop|
      sched += stop.time_to_post.strftime('%l:%M%P')
      sched += " - " + stop.name + "\n"
    end   
    return sched
  end
  
  def self.create_itinerary_from_checkin(checkin, user)
    itin = self.new
    itin.foursquare_user = user
    itin.checkin_id = checkin['id']
    itin.save
    start = Time.now
    itin.stops.create({ :name => "stop 1", :time_to_post => start + 10.minutes})
    itin.stops.create({ :name => "stop 2", :time_to_post => start + 100.minutes})
    itin.stops.create({ :name => "stop 3", :time_to_post => start + 200.minutes})
    return itin
  end
end
