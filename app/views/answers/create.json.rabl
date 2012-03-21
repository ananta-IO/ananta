object @answer

attributes :id, :state

child(:question) do
	# attributes :id, :question, :yes_count, :no_count, :dont_care_count, :answer_count  
	# node(:vote_count) { |question| question.plusminus } 
	extends("questions/show")
end