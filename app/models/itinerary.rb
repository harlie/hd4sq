class Itinerary < ActiveRecord::Base
  has_many :stops
  belongs_to :foursquare_user
  attr_accessible :checkin_id, :foursquare_user_id, :approved, :demo,:zip,:tz_offset,:lat_lng
  
  def to_s
    self.checkin_id
  end
  
  def to_reply
    sched = ''
    stops.each do |stop|
      #sched += stop.local_time_to_post.strftime('%l:%M%P')
      # sched += " - " +
      sched += stop.name + "\n"
    end   
    return sched
  end
  
  def self.create_itinerary_from_checkin(checkin, user)
    itin = self.new
    itin.foursquare_user = user
    itin.checkin_id = checkin['id']
    itin.demo = false
    itin.tz_offset = checkin['timeZoneOffset'].to_s.gsub(/(-?)(\d+)(\d{2})/, "\\1#{'\2'.rjust(3, '0')}:\\3")
    itin.lat_lng = checkin['venue']['location']['lat'].to_s + "," + checkin['venue']['location']['lng'].to_s
    itin.zip = checkin['venue']['zip']
    if checkin["shout"] && checkin['shout'] =~ /#demo/ 
      itin.demo = true 
    end
    itin.save
    itin.fill_it_out(0)
    return itin
  end
  
  def make_foursquare_stop(params, time, shout)
    url = "https://api.foursquare.com/v2/venues/explore?v=20130105&ll=#{self.lat_lng}&radius=2000&friendVisits=notvisited&oauth_token=#{self.foursquare_user.access_token}&#{params}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    result = JSON.parse(response.body)
    name = result['response']['groups'][0]['items'][0]['venue']['name']
    venue_id = result['response']['groups'][0]['items'][0]['venue']['id']
    lat_lng = result['response']['groups'][0]['items'][0]['venue']['location']['lat'].to_s + "," +result['response']['groups'][0]['items'][0]['venue']['location']['lng'].to_s 
    zip = result['response']['groups'][0]['items'][0]['venue']['location']['postalCode'].to_s
    self.stops.create({ :name => name, :time_to_post => time, :venue_id => venue_id, :shout => shout})
  end
  
  def make_jambase_stop(params, time, shout)
    #get jambase data
    date = time.strftime('%m/%d/%y')
    url = "http://api.jambase.com/search?apikey=78hjynre9at8tk4grtq3fdz7&zip=#{self.zip}&radius=10&startDate=#{date}&endDate=#{date}&#{params}"
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    doc = REXML::Document.new(xml_data)
    venue_name = doc.elements['JamBase_Data/event/venue/venue_name'].text
    name = doc.elements['JamBase_Data/event/artists/artist/artist_name'].text + " @ " + venue_name
    venue_zip = doc.elements['JamBase_Data/event/venue/venue_zip'].text
    
    #match to foursq
    url = "https://api.foursquare.com/v2/venues/search?v=20130105&near=#{venue_zip}&query=#{ CGI.escape(venue_name)}&oauth_token=#{self.foursquare_user.access_token}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    result = JSON.parse(response.body)
    venue_id = result['response']['venues'][0]['id']
    
    self.stops.create({ :name => name, :time_to_post => time, :venue_id => venue_id, :shout => shout})
  end
  
  def fill_it_out(route)
    routes = YAML.load_file("#{Rails.root}/config/itineraries.yml")
    next_time = Time.now + 30.minutes
  
    routes[route]['path'].each do |stop|
      params = stop['params'] ? stop['params'] : ""
      shout_idx = Random.rand(stop['shouts'].length)
      shout = stop['shouts'][shout_idx]
      case stop['api']
      when 'foursquare'
        self.make_foursquare_stop(params, next_time, shout)
      when 'jambase'
        self.make_jambase_stop(params, next_time, shout)    
      end
      next_time =  next_time + (80 + Random.rand(40)).minutes
      
    end
    
  end
  
  def refill(route)
    self.stops.delete_all
    fill_it_out(route)
  end
  
end
