class Ananta.Routers.ProjectFlowRouter extends Backbone.Router
	initialize: (options) ->
		_.bindAll(@, 'navigateTo')
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
		renderCallback = =>
			@view = new Ananta.Views.ProjectFlow.ProjectNameView({ model: @model, collection: @collection, router: @ })
			$("#project_flow").html(@view.render().el)
		@transitionTo(0, renderCallback)

	tags: ->
		renderCallback = =>
			@view = new Ananta.Views.ProjectFlow.ProjectTagsView({ model: @model, collection: @collection, router: @ })
			$("#project_flow").html(@view.render().el)
		@transitionTo(1, renderCallback)

	# Transitions / Animation
	nextStep: ->
		@navigateTo(@currentPage + 1)

	previousStep: ->
		@navigateTo(@currentPage - 1)
			
	stepForward: (renderCallback) ->
		$(@view.el).addClass('animated fadeOutLeftBig')
		wait 400, () =>
			@view.close()
			renderCallback()
			$(@view.el).addClass('animated fadeInRightBig')
			wait 1000, () =>
				$(@view.el).removeClass('animated fadeInRightBig')

	stepBack: (renderCallback) ->
		$(@view.el).addClass('animated fadeOutRightBig')
		wait 400, () =>
			@view.close()
			renderCallback()
			$(@view.el).addClass('animated fadeInLeftBig')
			wait 1000, () =>
				$(@view.el).removeClass('animated fadeInLeftBig')

	stepIn: (renderCallback) ->
		if @view?
			$(@view.el).addClass('animated fadeOutUp')
			wait 400, () =>
				@view.close()
				renderCallback()
				$(@view.el).addClass('animated fadeInUp')
		else
			renderCallback()
			$(@view.el).hide().fadeIn(8000)

	transitionTo: (page, renderCallback) ->
		previousPage = @currentPage
		@currentPage = page
		if previousPage < page
			@stepForward(renderCallback)
		else if previousPage > page
			@stepBack(renderCallback)
		else
			@stepIn(renderCallback)

	navigateTo: (page) ->
		if page < 0 then page = 0
		if page >=  @pages.length then page = (@pages.length - 1)
		target = @pages[page]
		@navigate(target, {trigger: true, replace: false})