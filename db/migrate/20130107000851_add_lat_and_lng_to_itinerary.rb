class AddLatAndLngToItinerary < ActiveRecord::Migration
  def change
    add_column :itineraries, :lat, :string
    add_column :itineraries, :lng, :string
    Itinerary.all.each do |itin|
      if itin.lat_lng
        (itin.lat,itin.lng) = itin.lat_lng.split(',')
        itin.save
      end
    end
    remove_column :itineraries, :lat_lng
  end
end
