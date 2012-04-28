class Ananta.Routers.ProjectFlowRouter extends Backbone.Router
	initialize: (options) ->
		@projects =  new Ananta.Collections.ProjectsCollection({})

	routes:
		".*" : "index"

	index: ->
		view = new Ananta.Views.ProjectFlow.ProjectFlowView({ collection: @projects })
		$("#project_flow").html(view.render().el)