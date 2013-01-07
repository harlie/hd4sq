class ItinerariesController < ApplicationController
  layout "itineraries"
  def show
    @itinerary = Itinerary.find_by_checkin_id(params[:id])
    url = "https://api.instagram.com/v1/media/search?lat=#{@itinerary.lat}&lng=#{@itinerary.lng}&client_id=37d734676df34625a720f41c0da22479"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    result = JSON.parse(response.body)
    STDERR.puts result.to_json
    @image = { :src => result['data'][0]['images']['low_resolution']['url'], 
             :url => result['data'][0]['link'],
            :user => result['data'][0]['user']['username']}
    
  end
  
  def update
     @itinerary = Itinerary.find_by_checkin_id(params[:id])
     @itinerary.update_attributes(params[:itinerary])
     if (params['route'])
       @itinerary.refill(params['route'].to_i)
     end
     @itinerary.reload
     if (@itinerary.demo && @itinerary.approved? )
       @itinerary.stops.each do |stop|
         begin
           stop.check_in
         rescue
         end   
       end
       FollowUpMailer::follow_up(@itinerary).deliver
     end
     redirect_to itinerary_path(@itinerary.to_s)
  end
  
  def edit 
    @itinerary = Itinerary.find_by_checkin_id(params[:id])
    @routes = YAML.load_file("#{Rails.root}/config/itineraries.yml")
  end
end