class AddTzOffsetToItinerary < ActiveRecord::Migration
  def change
    add_column :itineraries, :tz_offset, :string
  end
end
