class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.integer :itinerary_id
      t.string :name
      t.string :venue_id
      t.datetime :time_to_post
      t.boolean :complete

      t.timestamps
    end
  end
end
