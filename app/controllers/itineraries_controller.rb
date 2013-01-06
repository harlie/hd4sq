class ItinerariesController < ApplicationController
  layout "pretty"
  def show
    @itinerary = Itinerary.find_by_checkin_id(params[:id])
    if @itinerary.demo
      @itinerary.update_attributes(params[:itinerary])
      if @itinerary.demo
        @itinerary.stops.each do |stop|
           stop.check_in
        end
        FollowUpMailer::follow_up(@itinerary).deliver
      end
      redirect_to 'http://www.couchcachet.com/screen-grab.html'
    end
  end
  
  def update
     @itinerary = Itinerary.find_by_checkin_id(params[:id])
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