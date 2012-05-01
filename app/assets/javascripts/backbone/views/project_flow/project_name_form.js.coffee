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
		@projectNames = [
			'_____', 
			'baking', 
			'building a robot', 
			'building a tree-house', 
			'building a website', 
			'buying a toothbrush', 
			'coding', 
			'destabilizing electrons', 
			'drawing a blank', 
			'filming a movie',  
			'getting married', 
			'going on a date', 
			'going to start a project',
			'having fun yet', 
			'inspiring kids to dream big', 
			'learning a language', 
			'looking for someone to make stuff with', 
			'looking for something to do', 
			'meditating', 
			'mowing the lawn', 
			'reticulating splines', 
			'starting a company', 
			'teaching adults to think for themselves', 
			'thinking', 
			'training for a marathon', 
			'traveling the world', 
			'trying to loose weight', 
			'writing a book'
		]

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
