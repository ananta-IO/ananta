object @question

attributes :id, :question, :answer_count, :yes_count, :no_count, :dont_care_count, :avg_relevance, :questionable_controller, :questionable_action, :questionable_sid, :questionable_url, :score
node(:vote_count) { |question| question.plusminus } 

child(:user) do
	attributes :id, :name
	node(:url) { |user| profile_url(user) }
end