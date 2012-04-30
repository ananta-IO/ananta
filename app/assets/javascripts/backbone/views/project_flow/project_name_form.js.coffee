Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectNameFormView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_name_form']

	className: 'project-name-form'

	events:
		'submit form'             		:'submit'
		'mouseout .icon.blueprint'		:'randomizeIconTooltip'

	initialize: (options) ->
		_.bindAll(@, 'render')
		@model = new Ananta.Models.Project
		@model.urlRoot = "/#{Ananta.App.currentUser.id}"
		@projectNames = ['building a robot', 'building a website', 'building a tree-house', 'mowing the lawn', 'filming a movie', 'writing a book', 'starting a company', 'learning a language', 'playing a prank', 'having fun yet', 'teaching adults to think for themselves', 'traveling the world', 'inspiring kids to dream big', '_____', 'drawing a blank', 'destabilizing electrons', 'reticulating splines', 'having fun!', 'buying a toothbrush', 'loosing 10 pounds', 'gaining 10 pounds', 'training', 'thinking', 'baking', 'coding', 'meditating', 'looking for someone to make stuff with', 'going to start a project']

	render: ->
		$(@el).html(@template())
		@addTooltips()
		@

	addTooltips: ->
		@$('input').tooltip
			placement: 'top'
		@$('.icon.blueprint').tooltip
			placement: 'right'
			title: @randSugquestion()

	hideTooltips: ->
		@$('input').tooltip('hide')
		@$('.icon.blueprint').tooltip('hide')

	randomizeIconTooltip: ->
		@$('.icon.blueprint').attr('data-original-title', @randSugquestion())

	randSugquestion: ->
		"Are you #{@projectNames[Math.floor(Math.random()*@projectNames.length)]}?"

	submit: (e) ->
		e.preventDefault()
		e.stopPropagation()
		@$('input').attr('disabled', 'disabled')
		@model.set('name', @$('input').val())
		@model.save({}
			success: (data) =>
				@collection.add(@model)
				@hideTooltips()
				@.trigger('removeProjectNameForm')
			error: =>
				@$('input').removeAttr('disabled')
		)
