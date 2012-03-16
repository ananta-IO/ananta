class Ananta.Routers.MarqRouter extends Backbone.Router
	initialize: (options) ->
		@questions =  new Ananta.Collections.QuestionsCollection([], {query : "?per=1&unanswered_by=me&order=score&answered_by=ireadthecode"})
		
		# We don't need any routes yet. Always route to index
		@index()

	# routes:
	#	".*" : "index"

	index: ->
		@questions.fetch success: (collection) =>
			view = new Ananta.Views.Marq.MarqView({ collection: @questions })
			$("#marq").html(view.render().el)