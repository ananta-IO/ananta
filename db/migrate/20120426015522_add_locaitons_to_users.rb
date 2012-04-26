class AddLocaitonsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    
    add_index "users", ["latitude", "longitude"]
  end
end
