class ItinerariesController < ApplicationController
  layout "pretty"
  def show
    @itinerary = Itinerary.find_by_checkin_id(params[:id])
  end
  
  def update
     @itinerary = Itinerary.find_by_id(params[:id])
     @itinerary.update_attributes(params[:itinerary])
     if @itinerary.demo
       @itinerary.stops.each do |stop|
         stop.check_in
       end
       FollowUpMailer::follow_up(@itinerary).deliver
     end
     render 'show'
  end
end