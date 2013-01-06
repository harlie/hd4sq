class FollowUpMailer < ActionMailer::Base
  default from: "mailer@couchcachet.com"

  def follow_up(itinerary)
    @itinerary = itinerary
    @itinerary.zip =  @itinerary.zip ?  @itinerary.zip : 10001
    start_date = Time.now.strftime('%m/%d/%y')
    end_date = (Time.now + 1.week).strftime('%m/%d/%y')
    url = "http://api.jambase.com/search?apikey=78hjynre9at8tk4grtq3fdz7&zip=#{@itinerary.zip}&radius=10&startDate=#{start_date}&endDate=#{end_date}"
    STDERR.puts url
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    doc = REXML::Document.new(xml_data)
    @shows = Array.new
   # doc.elements['JamBase_Data/event'].each do |event|
  #    venue_name = event.elements['venue/venue_name'].text
  #    date = event.elements['event_date'].text
  #    artist = event.elements['JamBase_Data/event/artists/artist/artist_name'].text 
  #    @shows << "#{date} - #{artist} @  #{venue_name}"
  #  end
    
    url ="http://api.amp.active.com/search?v=json&l=#{@itinerary.zip}&api_key=EJZBN9Q8AG76TV49P5M5DRR5&m=meta:startDate:daterange:today..week"    
    json_data = Net::HTTP.get_response(URI.parse(url)).body
    @activities = Array.new
    active = JSON.parse(json_data)
    active['_results'].each do |res|
      date = res['meta']['startDate'].gsub(/\d*-(\d*)-(\d*)/, '\1/\2')
      @activities << { :title => res['title'], :date => date , :url => res['url']}
    end
    mail to: @itinerary.foursquare_user.get_email, subject: "Get off your couch"
    
  end
end