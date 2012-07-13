class CreateLocations < ActiveRecord::Migration
	def change
		create_table :locations do |t|
			t.references :locatable, :polymorphic => true
			t.string :name, :default => 'default'
			t.string :address
			t.string :timezone    
			t.float  :lat
			t.float  :lng
			t.text	 :data

			t.timestamps
		end
		add_index "locations", ["address"]
		add_index "locations", ["locatable_id", "locatable_type"]
		add_index "locations", ["lat", "lng"]
	end
end
