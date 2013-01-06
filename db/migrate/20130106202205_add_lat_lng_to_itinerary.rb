class AddLatLngToItinerary < ActiveRecord::Migration
  def change
    add_column :itineraries, :lat_lng, :string
  end
end
