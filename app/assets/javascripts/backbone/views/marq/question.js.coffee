Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.QuestionView extends Backbone.View
	template: JST['backbone/templates/marq/question']

	className: 'span5 question'

	initialize: (options) ->
		_.bindAll(@, 'render')

	render: ->
		$(@el).html(@template( @model.toJSON() ))
		@