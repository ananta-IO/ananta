class AddLocaitonsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string
    add_column :users, :lat, :float
    add_column :users, :lng, :float
    
    add_index "users", ["lat", "lng"]
  end
end
