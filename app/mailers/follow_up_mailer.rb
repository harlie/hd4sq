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
    doc.elements['JamBase_Data/event'].each do |event|
      venue_name = doc.elements['venue/venue_name'].text
      date = doc.elements['event_date'].text
      artist = doc.elements['JamBase_Data/event/artists/artist/artist_name'].text 
      @shows << "#{date} - #{artist} @  #{venue_name}"
    end
    
    
    
    mail to: @itinerary.foursquare_user.get_email, subject: "Get off your couch"
    
  end
end