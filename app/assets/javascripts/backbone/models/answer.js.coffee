class Ananta.Models.Answer extends Backbone.Model
	toJSON : () =>
		'answer': _.clone(@attributes)

class Ananta.Collections.AnswersCollection extends Backbone.Collection
	model: Ananta.Models.Answer