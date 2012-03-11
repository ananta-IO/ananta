Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.QuestionView extends Backbone.View
	template: JST['backbone/templates/marq/question']

	className: 'span5'

	events:
		'click textarea'		: 'stopPropagation'

	initialize: (options) ->
		_.bindAll(@, 'render', 'stopPropagation')

	render: ->
		$(@el).html(@template( @model.toJSON() ))
		@

	stopPropagation: (e) ->
		e.stopPropagation()