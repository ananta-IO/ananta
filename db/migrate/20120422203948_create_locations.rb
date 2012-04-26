class CreateLocations < ActiveRecord::Migration
	def change
		create_table :locations do |t|
			t.references :locatable, :polymorphic => true
			t.string :name, :default => 'default'
			t.string :street
			t.string :city
			t.string :state
			t.string :zipcode
			t.string :timezone    
			t.string :country, :default => 'US'    
			t.float  :latitude
			t.float  :longitude

			t.timestamps
		end
		add_index "locations", ["locatable_id", "locatable_type"]
		add_index "locations", ["city", "state"]
		add_index "locations", ["zipcode"]
		add_index "locations", ["country"]
		add_index "locations", ["latitude", "longitude"]
	end
end
