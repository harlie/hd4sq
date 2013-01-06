class AddFieldsToFoursquareUser < ActiveRecord::Migration
  def change
    add_column :foursquare_users, :name, :string
    add_column :foursquare_users, :email, :string
    add_column :foursquare_users, :phone, :string
  end
end
