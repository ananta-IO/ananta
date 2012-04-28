Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectFlowView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_flow']

	className: 'row'

	initialize: (options) ->
		_.bindAll(@, 'render', 'removeProjectNameForm')

	render: ->
		$(@el).html(@template())
		@addProjectNameForm().hide().fadeIn(10000)
		@

	addProjectNameForm: ->
		view = new Ananta.Views.ProjectFlow.ProjectNameFormView({collection : @collection})
		view.bind('removeProjectNameForm', @removeProjectNameForm)
		el = $(view.render().el)
		$(@el).append(el)
		el

	removeProjectNameForm: ->
		old = @$('.project-name-form')
		old.addClass('animated fadeOutLeftBig')
		wait 400, () =>
			old.remove()
			wait 200, () =>
				@addProjectNameForm().addClass('animated fadeInUp')