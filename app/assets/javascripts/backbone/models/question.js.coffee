class Ananta.Models.Question extends Backbone.Model
	urlRoot: '/questions'

class Ananta.Collections.QuestionsCollection extends Backbone.Collection
	model: Ananta.Models.Question
	url: '/questions'
