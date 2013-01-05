class CreateItineraries < ActiveRecord::Migration
  def change
    create_table :itineraries do |t|
      t.integer :foursquare_user_id
      t.string :checkin_id

      t.timestamps
    end
  end
end
