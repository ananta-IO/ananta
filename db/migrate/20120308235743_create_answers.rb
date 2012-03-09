class CreateAnswers < ActiveRecord::Migration
	def change
		create_table :answers do |t|
			t.integer :user_id
			t.integer :question_id
			t.string :state
			t.string :comment

			t.timestamps
		end
		add_index "answers", ["user_id"]
		add_index "answers", ["question_id"]
		add_index "answers", ["state"]
	end
end
