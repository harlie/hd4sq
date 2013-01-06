class AddDemoToItinerary < ActiveRecord::Migration
  def change
    add_column :itineraries, :demo, :boolean
  end
end
