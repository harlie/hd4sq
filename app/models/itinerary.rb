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
    itin.fill_it_out(checkin)
    return itin
  end
  
  def fill_it_out(checkin)
    start = Time.now
    demo = false
    if checkin["shout"] && checkin['shout'] =~ /#demo/ 
      demo = true 
    else
      start += 30.minutes
    end
    #restaurant
    self.stops.create({ :name => "stop 2", :time_to_post => start})
    next_time = demo ? start : start + (80 + Random.rand(40)).minutes
    #concert
    
    #bar
    self.stops.create({ :name => "stop 2", :time_to_post => next_time   })
    
  end
end
