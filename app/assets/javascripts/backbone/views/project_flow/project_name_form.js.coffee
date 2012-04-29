Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectNameFormView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_name_form']

	className: 'project-name-form'

	events:
		'submit form'		:'submit'

	initialize: (options) ->
		_.bindAll(@, 'render')
		@model = new Ananta.Models.Project
		@model.urlRoot = "/#{Ananta.App.currentUser.id}"

	render: ->
		$(@el).html(@template())
		@addTooltips()
		@

	addTooltips: ->
		@$('input').tooltip
			placement: 'top'

	submit: (e) ->
		e.preventDefault()
		e.stopPropagation()
		@model.set('name', @$('input').val())
		@model.save()
		@collection.add(@model)
		@.trigger('removeProjectNameForm')
