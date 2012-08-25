class Ananta.Routers.MarqRouter extends Backbone.Router
	initialize: (options) ->
		qc = if options.q_controller then "&q_controller=#{options.q_controller}" else ''
		qa = if options.q_action then "&q_action=#{options.q_action}" else ''
		qs = if options.q_sid then "&q_sid=#{options.q_sid}" else ''
		query = "?unanswered_by=me#{qc}#{qa}#{qs}&order=score&per=1&select=id,question,questionable_controller,questionable_action,questionable_sid"
		@questions =  new Ananta.Collections.QuestionsCollection([], {query : query})
		
		# We don't need any routes yet. Always route to index
		@index()

	# routes:
	#	"*actions" : "index"

	index: ->
		Ananta.App.marqView = new Ananta.Views.Marq.MarqView({ collection: @questions })
		$("#marq").html(Ananta.App.marqView.render().el)