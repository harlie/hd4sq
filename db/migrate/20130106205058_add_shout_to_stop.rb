class AddShoutToStop < ActiveRecord::Migration
  def change
    add_column :stops, :shout, :text
  end
end
