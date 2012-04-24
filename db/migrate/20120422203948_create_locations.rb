class CreateLocations < ActiveRecord::Migration
	def change
		create_table :locations do |t|
			t.integer :user_id
			t.string :name
			t.string :address
			t.string :city
			t.string :state
			t.string :zipcode
			t.string :time_zone    
			t.float  :latitude
			t.float  :longitude

			t.timestamps
		end
		add_index "locations", ["user_id"]
		add_index "locations", ["city", "state"]
		add_index "locations", ["zipcode"]
		add_index "locations", ["latitude", "longitude"]
	end
end
