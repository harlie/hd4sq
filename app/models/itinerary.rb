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
    lat_lng = checkin['venue']['location']['lat'].to_s + "," + checkin['venue']['location']['lng'].to_s
    url = "https://api.foursquare.com/v2/venues/explore?v=20130105&ll=#{lat_lng}&radius=2000&section=food&friendVisits=notvisited&oauth_token=#{self.foursquare_user.access_token}"
    STDERR.puts url
    response = HTTParty.get(url)
    STDERR.puts response.to_json
    result = JSON.parse(response.body)
    STDERR.puts result.to_json
    name = result['response']['groups'][0]['items'][0]['venue']['name']
    venue_id = result['response']['groups'][0]['items'][0]['venue']['name']
    self.stops.create({ :name => name, :time_to_post => start, :venue_id => venue_id})
    next_time = demo ? start : start + (80 + Random.rand(40)).minutes
    #concert
    
    #bar
    self.stops.create({ :name => "stop 2", :time_to_post => next_time   })
    
  end
end
