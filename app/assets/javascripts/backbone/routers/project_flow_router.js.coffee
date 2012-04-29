class Ananta.Routers.ProjectFlowRouter extends Backbone.Router
	initialize: (options) ->
		Ananta.App.currentUser = new Ananta.Models.User(options.currentUser)
		@projects =  new Ananta.Collections.ProjectsCollection()

	routes:
		".*" : "index"

	index: ->
		view = new Ananta.Views.ProjectFlow.ProjectFlowView({ collection: @projects })
		$("#project_flow").html(view.render().el)