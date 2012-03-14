class Ananta.Models.Session extends Backbone.Model
	urlRoot: '/sessions'

class Ananta.Collections.SessionsCollection extends Backbone.Collection
	model: Ananta.Models.Session
	initialize: (models, options) ->
		if options then @query = options.query else @query = ''
	url: ->
		"/sessions#{@query}"
