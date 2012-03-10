class CreateQuestions < ActiveRecord::Migration
	def change
		create_table :questions do |t|
			t.integer :user_id
			t.string :questionable_url
			t.string :question
			t.string :state
			t.integer :yeses, default: 0
			t.integer :noes, default: 0
			t.integer :dont_cares, default: 0

			t.timestamps
		end
		add_index "questions", ["user_id"]
		add_index "questions", ["questionable_url"]
		add_index "questions", ["question"]
		add_index "questions", ["state"]
		add_index "questions", ["yeses"]
		add_index "questions", ["noes"]
		add_index "questions", ["dont_cares"]
	end
end
