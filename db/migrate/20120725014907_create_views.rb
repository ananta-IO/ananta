class CreateViews < ActiveRecord::Migration
	def change
		create_table :views do |t|
			t.references :viewable, :polymorphic => true
			t.integer :user_id
			t.string :ip

			t.timestamps
		end

		add_index "views", ["viewable_id", "viewable_type"]
		add_index "views", ["user_id"]
		add_index "views", ["ip"]
	end
end
