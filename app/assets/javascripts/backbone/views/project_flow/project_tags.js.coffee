Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectTagsView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_tags']

	className: 'row-fluid'

	events:
		'click .submit-tags'       : 'save'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderSelectionCountdown', 'renderPreview')
		@router = options.router
		@tags = new Backbone.Collection()
		@maxTags = 5

	render: ->
		$(@el).html(@template())
		@renderTags()
		@renderSelectionCountdown()
		@renderPreview()
		@

	renderSelectionCountdown: ->
		@$('.count.remaining').html(@selectionCountdown())

	renderPreview: ->
		@$('ul.preview').html('') 
		for tag in @tags.where({ selected : true })
			@$('ul.preview').append("<li class='span1'><span class='thumbnail center'><i class='tag #{tag.get('name')}', data-tag='#{tag.get('name')}''></i></span></li>")

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
			tag = new Backbone.Model
				name : icon 
				selected : if @model.get('tag_tokens')? and icon in @model.get('tag_tokens') then true else false
			@tags.add tag
			view =  new Ananta.Views.ProjectFlow.ProjectTagView({ model : tag, parent : @ })
			view.bind('renderSelectionCountdown', @renderSelectionCountdown)
			view.bind('renderPreview', @renderPreview)
			@$(".tags").append(view.render().el)

	selectionCountdown: ->
		@maxTags - @tags.where({ selected : true }).length

	save: ->
		selection = new Backbone.Collection(@tags.where({ selected : true }))
		tag_tokens = selection.pluck('name')
		@model.set({tag_tokens: tag_tokens})
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