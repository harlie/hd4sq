class AddApprovedToItineraries < ActiveRecord::Migration
  def change
    add_column :itineraries, :approved, :boolean
  end
end
