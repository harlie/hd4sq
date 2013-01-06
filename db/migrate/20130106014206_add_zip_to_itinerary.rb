class AddZipToItinerary < ActiveRecord::Migration
  def change
    add_column :itineraries, :zip, :string
  end
end
