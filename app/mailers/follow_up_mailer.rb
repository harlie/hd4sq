class FollowUpMailer < ActionMailer::Base
  default from: "mailer@couchcachet.com"

  def follow_up(itinerary)
    return unless itinerary.foursquare_user.email
    @itinerary = itinerary
    @itinerary.zip =  @itinerary.zip ?  @itinerary.zip : 10001
    start_date = Time.now.strftime('%m/%d/%y')
    end_date = (Time.now + 1.week).strftime('%m/%d/%y')
    url = "http://api.jambase.com/search?apikey=78hjynre9at8tk4grtq3fdz7&zip=#{@itinerary.zip}&radius=10&n=10&user=jambase&startDate=#{start_date}&endDate=#{end_date}"
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    doc = XmlSimple.xml_in(xml_data, { 'KeyAttr' => 'name' })    
    @shows = Array.new
    doc['event'].each do |event|
      venue_name = event['venue'][0]['venue_name'][0]
      date = event['event_date'][0].gsub(/(\d*\/\d*)\/\d*/, '\1')
      artist = event['artists'][0]['artist'][0]['artist_name'][0]
      event_url = event['event_url'][0]
      @shows << { :title => "#{artist} @ #{venue_name}", :date => date , :url => event_url}
    end
    
    url ="http://api.amp.active.com/search?v=json&l=#{@itinerary.zip}&api_key=EJZBN9Q8AG76TV49P5M5DRR5&m=meta:startDate:daterange:today..week"    
    json_data = Net::HTTP.get_response(URI.parse(url)).body
    @activities = Array.new
    active = JSON.parse(json_data)
    active['_results'].each do |res|
      date = res['meta']['startDate'].gsub(/\d*-0*(\d*)-0*(\d*)/, '\1/\2')
      @activities << { :title => res['title'], :date => date , :url => res['url']}
    end
    mail to: @itinerary.foursquare_user.email, subject: "Get off your couch"
    
  end
end