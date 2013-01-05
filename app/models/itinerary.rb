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
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    STDERR.puts response.body
    
    
    result = JSON.parse(response.body)
    STDERR.puts result.to_s
    name = result['response']['groups'][0]['items'][0]['venue']['name']
    venue_id = result['response']['groups'][0]['items'][0]['venue']['name']
    lat_lng = result['response']['groups'][0]['items'][0]['venue']['location']['lat'].to_s + "," +result['response']['groups'][0]['items'][0]['venue']['location']['lng'].to_s 
    zip = result['response']['groups'][0]['items'][0]['venue']['location']['postalCode'].to_s
    self.stops.create({ :name => name, :time_to_post => start, :venue_id => venue_id})
    next_time = demo ? start : start + (80 + Random.rand(40)).minutes
    
    #concert
    date = next_time.strftime('%m/%d/%y')
    url = "http://api.jambase.com/search?apikey=78hjynre9at8tk4grtq3fdz7&zip=#{zip}&radius=10&startDate=#{date}&endDate=#{date}"
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    doc = REXML::Document.new(xml_data)
    venue_name = doc.elements['JamBase_Data/event/venue/venue_name'].text
    name = doc.elements['JamBase_Data/event/artists/artist/artist_name'].text + " @ " + venue_name
    venue_zip = doc.elements['JamBase_Data/event/venue/venue_zip'].text
    url = "https://api.foursquare.com/v2/venues/search?v=20130105&near=#{venue_zip}&query=#{ CGI.escape(venue_name)}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    
    result = JSON.parse(response.body)
    venue_id = result['response']['groups'][0]['items'][0]['venue']['name']
    lat_lng = result['response']['groups'][0]['items'][0]['venue']['location']['lat'].to_s + "," +result['response']['groups'][0]['items'][0]['venue']['location']['lng'].to_s 
    self.stops.create({ :name => name, :time_to_post => next_time, :venue_id => venue_id})
    next_time = demo ? start : start + (80 + Random.rand(40)).minutes
    
    
    #bar
    url = "https://api.foursquare.com/v2/venues/explore?v=20130105&ll=#{lat_lng}&radius=2000&section=drinks&friendVisits=notvisited&oauth_token=#{self.foursquare_user.access_token}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    STDERR.puts response.body
    
    
    result = JSON.parse(response.body)
    STDERR.puts result.to_s
    name = result['response']['groups'][0]['items'][0]['venue']['name']
    venue_id = result['response']['groups'][0]['items'][0]['venue']['name']
    lat_lng = result['response']['groups'][0]['items'][0]['venue']['location']['lat'].to_s + "," +result['response']['groups'][0]['items'][0]['venue']['location']['lng'].to_s 
    self.stops.create({ :name => name, :time_to_post => next_time, :venue_id => venue_id})
    
  end
end
