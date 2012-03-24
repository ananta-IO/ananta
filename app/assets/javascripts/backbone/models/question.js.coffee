class Ananta.Models.Question extends Backbone.Model
	urlRoot: '/questions'

	toJSON : () =>
		'question': _.clone(@attributes)

class Ananta.Collections.QuestionsCollection extends Backbone.Collection
	model: Ananta.Models.Question
	initialize: (models, options) ->
		if options then @query = options.query else @query = ''
	url: ->
		"/questions#{@query}"
