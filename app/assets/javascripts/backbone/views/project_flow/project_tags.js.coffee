Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectTagsView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_tags']

	className: 'row-fluid'

	events:
		'click .submit-tags'       : 'save'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderSelectionCountdown', 'renderPreview', 'deselectTag')
		@router = options.router
		@tags = new Backbone.Collection()
		@maxTags = 5
		@order = 1

		@tags.bind('change', @renderSelectionCountdown)
		@tags.bind('change', @renderPreview)

	render: ->
		$(@el).html(@template(@model.toJSON()))
		@renderTags()
		@renderSelectionCountdown()
		@renderPreview()
		@

	renderSelectionCountdown: ->
		@$('.count.remaining').html(@selectionCountdown())

	renderPreview: ->
		@$('div.preview').html('') 
		window.tags = @tags
		for tag in @selectAndOrder(@tags)
			@$('div.preview').append("<div class='center'><a href='#' class='tag' data-tag='#{tag.get('name')}'><i class='#{tag.get('name')}'></i></a></div></li>")
		@$('.preview a.tag').click(@deselectTag)

	renderTags: ->
		icons = [
			# 'icom-blueprint'
			'icom-newspaper'
			'icom-pencil'
			'icom-droplet'
			'icom-camera'
			'icom-music'
			'icom-broadcast'
			'icom-microphone'
			'icom-book'
			'icom-cart'
			'icom-support'
			'icom-compass'
			'icom-phone'
			'icom-gift'
			'icom-rocket'
			'icom-lab'
			'icom-accessibility'
			'icom-share'
			'icom-movie'
			'icom-palette'
			'icom-video'
			'icom-tablet'
			'icom-cars'
			'icom-bus'
			'icom-flight'
			'icom-search'
			'icom-ninja'
			'icom-beach-ball'
			'icom-sewing'
			'icom-factory'
			'icom-fedora'
			'icom-splat'
			'icom-glasses'
			'icom-top-hat'
			'icom-video-game'
			'icom-earth'
			'icom-code'
			'icom-revolution'
			'icom-24hrs'
			'icom-brain'
			'icom-tv'
			'icom-laptop'
			'icom-recycle'
			'icom-puzzle'
			'icom-wrench'
			'icom-cube'
			'icom-coffee'
			'icom-trophy'
			'icom-home'
			'icom-college'
			'icom-robot'
			'icom-announce'
			'icom-soccer-ball'
			'icom-screw'
			'icom-light-bulb'
		]
		icons = @shuffle(icons)
		for icon in icons 
			if @model.get('tag_tokens')? and icon in @model.get('tag_tokens') then selected = true else selected = false
			if selected
				order = @model.get('tag_tokens').indexOf(icon) + 1 
				@nextOrder()
			else 
				order = 9000
			tag = new Backbone.Model
				name : icon 
				selected : selected
				order : order
			@tags.add tag
			view =  new Ananta.Views.ProjectFlow.ProjectTagView({ model : tag, parent : @ })
			@$(".tags").append(view.render().el)

	selectionCountdown: ->
		@maxTags - @selectAndOrder(@tags).length

	nextOrder: ->
		@order++

	selectAndOrder: (tags) ->
		tags.where({ selected : true }).sortBy((tag) -> tag.get('order'))

	deselectTag: (e) ->
		e.preventDefault()
		e.stopPropagation()
		name = $(e.target).attr('class')
		@tags.where({ selected : true, name : name })[0].set({selected : false})

	save: (e) ->
		e.preventDefault()
		e.stopPropagation()
		selection = new Backbone.Collection(@selectAndOrder(@tags))
		tag_tokens = selection.pluck('name')
		@model.set({tag_tokens: tag_tokens})
		Analytical.event('Project Flow - Submit Project Tags', { project_name: @model.get('name'), location: window.location.href } )
		@model.save({}
			success: (data) =>
				@collection.add(@model)
				window.location.href = @model.get('url')
				# $.getScript("/render_nav")
			error: (data, jqXHR) =>   
				if @model.get('name').length < 3
					@router.previousStep()
					wait 600, =>
						@alert('Please say a little more about what you are working on.', {title:'Before you continue'})
				else
					errors = $.parseJSON(jqXHR.responseText)
					@renderErrors errors,
						loginCallback  : null
		)

_.extend(Ananta.Views.ProjectFlow.ProjectTagsView::, Ananta.Mixins.Alerts)
_.extend(Ananta.Views.ProjectFlow.ProjectTagsView::, Ananta.Mixins.Collections)
_.extend(Ananta.Views.ProjectFlow.ProjectTagsView::, Ananta.Mixins.Errors)