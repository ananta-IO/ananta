Ananta.Views.ProjectFlow ||= {}

class Ananta.Views.ProjectFlow.ProjectTagView extends Backbone.View
	template: JST['backbone/templates/project_flow/project_tag']

	tagName: 'li'
	className: 'span2'

	events:
		'click a'	:'select'

	initialize: (options) ->
		_.bindAll(@, 'render')
		@parent = options.parent

		@model.bind('change', @render)

	render: ->
		$(@el).html(@template( @model.toJSON() ))
		@

	select: (e) ->
		e.preventDefault()
		e.stopPropagation()
		if @parent.selectionCountdown() > 0 or @model.get('selected')
			@model.set('selected', !@model.get('selected'))
			@.trigger('renderSelectionCountdown')
		else
			alert('max 5 tags')
