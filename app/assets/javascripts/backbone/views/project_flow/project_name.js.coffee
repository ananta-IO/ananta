Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectNameView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_name']

	className: 'row'

	events:
		'submit form'                   :'create'
		'click .project-action-search'  :'search'
		'click .project-action-start'   :'create'
		'mouseout span.hint'            :'randomizeIconTooltip'

	initialize: (options) ->
		_.bindAll(@, 'render')
		@router = options.router
		@projectNames = [
			'_____'
			'baking a cake'
			'brushing your teeth'
			'building a robot'
			'building a rocket'
			'building a tree-house'
			'building a website'
			'chasing your dreams'
			'confused'
			'destabilizing quantum states'
			'drawing a blank'
			'filming a movie' 
			'getting married'
			'going on a date'
			'going to start a project'
			'happy'
			'having fun yet'
			'inspiring kids to dream big'
			'learning a language'
			'looking for someone to make stuff with'
			'looking for something to do'
			'looking for test subjects'
			'meditating'
			'mowing the lawn'
			'painting a portrait'
			'paying it forward'
			'performing an experiment'
			'playing a game'
			'programming this website'
			'researching the mating habits of tree squirrels'
			'reticulating splines'
			'starting a band'
			'starting a company'
			'starting a revolution'
			'teaching adults to think for themselves'
			'thinking'
			'training for a marathon'
			'traveling the world'
			'traveling to other worlds'
			'trying to gain weight' 
			'trying to loose weight'
			'trying to take over the world'
			'writing a book'
			'writing a play'
			'writing a poem'
		]

		# @model.on "error", (model, error) =>
		#	alert("Project #{error.attr} #{error.msg}")
		#	@$('input').removeAttr('disabled').focus()

	render: ->
		$(@el).html(@template( @model.toJSON() ))
		@addTooltips()
		@

	addTooltips: ->
		@$('input').tooltip
			placement: 'top'
			delay: 300
		@$('span.hint').tooltip
			placement: 'right'
			title: @randSugquestion()

	hideTooltips: ->
		@$('input').tooltip('hide')
		@$('span.hint').tooltip('hide')

	randomizeIconTooltip: ->
		@$('span.hint').attr('data-original-title', @randSugquestion())

	randSugquestion: ->
		"Are you #{@projectNames[Math.floor(Math.random()*@projectNames.length)]}?"

	search: (e) ->
		e.preventDefault()
		e.stopPropagation()

	create: (e) ->
		e.preventDefault()
		e.stopPropagation()
		@$('input').attr('disabled', 'disabled').after('<img src="/assets/ajax-loader-black-dots.gif" class="loader" />')
		@model.set('name', @$('input').val())
		@model.save({}
		 	success: (data) =>
		 		@collection.add(@model)
		 		@hideTooltips()
		 		@router.nextStep()
		 		$.getScript("/render_nav")
		 	error: (data, jqXHR) =>   
		 		@$('input').removeAttr('disabled').focus()
		 		@$('.loader').remove()
		 		@hideTooltips()
		 		errors = $.parseJSON(jqXHR.responseText)
		 		@renderErrors errors,
		 			keysToRender   : ['name']
		 			loginCallback  : null
		)	

_.extend(Ananta.Views.ProjectFlow.ProjectNameView::, Ananta.Mixins.Errors)

