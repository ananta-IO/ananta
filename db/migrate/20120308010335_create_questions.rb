class CreateQuestions < ActiveRecord::Migration
	def change
		create_table :questions do |t|
			t.integer :user_id
			t.references :questionable, :polymorphic => true
			t.string :question
			t.string :state

			t.timestamps
		end
		add_index "questions", ["user_id"]
		add_index "questions", ["questionable_id", "questionable_type"]
		add_index "questions", ["question"]
		add_index "questions", ["state"]
	end
end
