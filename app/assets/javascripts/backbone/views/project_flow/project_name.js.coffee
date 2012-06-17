Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectNameView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_name']

	className: 'row'

	events:
		'submit form'                   :'create'
		'click .project-action-search'  :'search'
		'click .project-action-start'   :'create'
		'mouseout span.hint'            :'randomizeIconTooltip'
		'mouseout input'	            :'randomizeInputTooltip'

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
			'looking for your basketball'
			'meditating'
			'mowing the lawn'
			'painting a portrait'
			'paying it forward'
			'performing an experiment'
			'picking your nose'
			'planning a trip around the galaxy'
			'playing a game'
			'programming this website'
			'reticulating splines'
			'shooting a movie'
			'starting a band'
			'starting a company'
			'starting a revolution'
			'teaching adults to think for themselves'
			'thinking'
			'training for a marathon'
			'traveling the world'
			'trying to gain weight' 
			'trying to loose weight'
			'trying to take over the world'
			'writing a book'
			'writing a play'
			'writing a poem'
		]

	render: ->
		$(@el).html(@template( @model.toJSON() ))
		@addTooltips()
		@

	addTooltips: ->
		@$('input').tooltip
			placement: 'top'
			delay: 300
			title: ""
		@$('span.hint').tooltip
			placement: 'right'
			title: ""
		@randomizeInputTooltip()
		@randomizeIconTooltip()

	hideTooltips: ->
		@$('input').tooltip('hide')
		@$('span.hint').tooltip('hide')

	randomizeIconTooltip: ->
		@$('span.hint').attr('data-original-title', "Are you #{@randSugguestion()}?")
	
	randomizeInputTooltip: ->
		@$('input').attr('data-original-title', "Name one thing you are working on. <br/> Even if you're just #{@randSugguestion()}, we want to hear about it.")

	randSugguestion: ->
		@projectNames[Math.floor(Math.random()*@projectNames.length)]

	search: (e) ->
		e.preventDefault()
		e.stopPropagation()

	create: (e) ->
		e.preventDefault()
		e.stopPropagation()
		@$('input').attr('disabled', 'disabled').after('<img src="/assets/ajax-loader-black-dots.gif" class="loader" />')
		@model.set({'name': @$('input').val()})
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
				@router.nextStep() unless Ananta.App.currentUser.id? # let new users glimpse the tags
		)   

_.extend(Ananta.Views.ProjectFlow.ProjectNameView::, Ananta.Mixins.Errors)

