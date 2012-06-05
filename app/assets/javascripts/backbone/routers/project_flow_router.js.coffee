class Ananta.Routers.ProjectFlowRouter extends Backbone.Router
	initialize: (options) ->
		_.bindAll(@, 'render')
		Ananta.App.currentUser = new Ananta.Models.User(options.currentUser)
		@model = new Ananta.Models.Project()
		@model.urlRoot = "/#{Ananta.App.currentUser.id}"
		@collection =  new Ananta.Collections.ProjectsCollection()
		
		@pages = ["name", "tags"]
		@currentPage = 0

	routes:
		"name"     : "name"
		"tags"     : "tags"
		"*actions" : "name"

	name: ->
		render = =>
			@view = new Ananta.Views.ProjectFlow.ProjectNameView({ model: @model, collection: @collection, router: @ })
			$("#project_flow").html(@view.render().el)
		@stepTo(0, render)

	tags: ->
		render = =>
			@view = new Ananta.Views.ProjectFlow.ProjectTagsView({ model: @model, collection: @collection, router: @ })
			$("#project_flow").html(@view.render().el)
		@stepTo(1, render)

	# Rendering / Animation
	nextStep: ->
		@currentPage++
		@stepForward(@render)

	previousStep: ->
		@currentPage--
		@stepBack(@render)

	stepTo: (page, render) ->
		previousPage = @currentPage
		@currentPage = page
		if previousPage < page
			@stepForward(render)
		else if previousPage > page
			@stepBack(render)
		else
			@fadeIn(render)
			
	stepForward: (render) ->
		$(@view.el).addClass('animated fadeOutLeftBig')
		wait 400, () =>
			@view.close()
			render()
			$(@view.el).addClass('animated fadeInRightBig')
			wait 1000, () =>
				$(@view.el).removeClass('animated fadeInRightBig')

	stepBack: (render) ->
		$(@view.el).addClass('animated fadeOutRightBig')
		wait 400, () =>
			@view.close()
			render()
			$(@view.el).addClass('animated fadeInLeftBig')
			wait 1000, () =>
				$(@view.el).removeClass('animated fadeInLeftBig')

	fadeIn: (render) ->
		render()
		$(@view.el).hide().fadeIn(5000)

	render: ->
		if @currentPage < 0 then @currentPage = 0
		if @currentPage >=  @pages.length then @currentPage = (@pages.length - 1)
		target = @pages[@currentPage]
		@navigate(target, {trigger: true, replace: false})