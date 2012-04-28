Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectFlowView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_flow']

	className: 'row'

	initialize: (options) ->
		_.bindAll(@, 'render', 'removeProjectNameForm')

	render: ->
		$(@el).html(@template())
		@addProjectNameForm().hide().fadeIn(5000)
		@

	addProjectNameForm: ->
		@formView = new Ananta.Views.ProjectFlow.ProjectNameFormView({collection : @collection})
		@formView.bind('removeProjectNameForm', @removeProjectNameForm)
		$(@el).append(@formView.render().el)
		$(@formView.el)

	removeProjectNameForm: ->
		$(@formView.el).addClass('animated fadeOutLeftBig')
		wait 400, () =>
			@formView.remove()
			wait 100, () =>
				@addProjectNameForm().addClass('animated fadeInUp')
				wait 1000, () =>
					$(@formView.el).removeClass('animated fadeInUp')