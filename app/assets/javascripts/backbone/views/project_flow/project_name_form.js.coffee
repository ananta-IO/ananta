Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectNameFormView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_name_form']

	className: 'project-name-form'

	events:
		'submit form'		:'submit'

	initialize: (options) ->
		_.bindAll(@, 'render')

	render: ->
		$(@el).html(@template())
		@

	submit: (e) ->
		@.trigger('removeProjectNameForm')
		e.preventDefault()
		e.stopPropagation()
