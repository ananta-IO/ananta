class Ananta.Routers.MarqRouter extends Backbone.Router
	initialize: (options) ->
		@questions =  new Ananta.Collections.QuestionsCollection([], {query : "?per=1;pathname=#{window.location.pathname}"})

	routes:
		".*" : "index"

	index: ->
		@questions.fetch success: (collection) =>
			view = new Ananta.Views.Marq.MarqView({ collection: @questions })
			$("#marq").html(view.render().el)