Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectTagsView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_tags']

	className: 'project-tags span12'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderSelectionCountdown', 'renderPreview')
		@tags = new Backbone.Collection()
		@maxTags = 5

	render: ->
		$(@el).html(@template())
		@renderSelectionCountdown()
		@renderTags()
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
		icons = shuffle(icons)
		for icon in icons 
			tag = new Backbone.Model({ name : icon, selected : false })
			@tags.add tag
			view =  new Ananta.Views.ProjectFlow.ProjectTagView({ model : tag, parent : @ })
			view.bind('renderSelectionCountdown', @renderSelectionCountdown)
			view.bind('renderPreview', @renderPreview)
			@$(".tags").append(view.render().el)

	selectionCountdown: ->
		@maxTags - @tags.where({ selected : true }).length

	shuffle = (o) ->
		i = o.length
		while i
			j = parseInt(Math.random() * i)
			x = o[--i]
			o[i] = o[j]
			o[j] = x
		o
