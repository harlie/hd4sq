class ItinerariesController < ApplicationController
  layout "pretty"
  def show
    @itinerary = Itinerary.find_by_checkin_id(params[:id])
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
     render 'show'
  end
  
  def edit 
    @itinerary = Itinerary.find_by_checkin_id(params[:id])
    @routes = YAML.load_file("#{Rails.root}/config/itineraries.yml")
  end
end