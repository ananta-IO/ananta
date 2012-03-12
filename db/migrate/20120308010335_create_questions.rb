class CreateQuestions < ActiveRecord::Migration
	def change
		create_table :questions do |t|
			t.integer :user_id
			t.references :questionable, :polymorphic => true
			t.text :questionable_url
			t.string :questionable_action
			t.string :question
			t.string :state
			t.integer :answer_count, default: 0
			t.integer :yes_count, default: 0
			t.integer :no_count, default: 0
			t.integer :dont_care_count, default: 0
			t.integer :score, default: 1000

			t.timestamps
		end
		add_index "questions", ["user_id"]
		add_index "questions", ["questionable_id", "questionable_type"]
		add_index "questions", ["questionable_id"]
		add_index "questions", ["questionable_type"]
		add_index "questions", ["questionable_url"]
		add_index "questions", ["questionable_action"]
		add_index "questions", ["state"]
		add_index "questions", ["answer_count"]
		add_index "questions", ["yes_count"]
		add_index "questions", ["no_count"]
		add_index "questions", ["dont_care_count"]
		add_index "questions", ["score"]
	end
end
