class ItinerariesController < ApplicationController

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
     end
     render 'show'
  end
end