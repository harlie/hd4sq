class ItinerariesController < ApplicationController

  def show
    @itinerary = Itinerary.find_by_checkin_id(params[:id])
  end
end