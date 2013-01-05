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
    array = Time.now.to_a
    array[1] = array[1].round(-1)
    start = Time.utc(array)
    itin.stops.create({ :name => "stop 1", :time_to_post => start + 10.mins})
    itin.stops.create({ :name => "stop 2", :time_to_post => start + 100.mins})
    itin.stops.create({ :name => "stop 3", :time_to_post => start + 200.mins})
    
  end
end
