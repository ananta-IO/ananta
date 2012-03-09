class Ananta.Routers.MarqRouter extends Backbone.Router
	initialize: (options) ->
		@questions =  new Ananta.Collections.QuestionsCollection()
		@questions.fetch()

	routes:
		".*" : "index"

	index: ->
		view = new Ananta.Views.Marq.MarqView({ questions: @questions })
		$("#marq").html(view.render().el)