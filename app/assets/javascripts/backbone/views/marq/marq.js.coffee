Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.MarqView extends Backbone.View
	template: JST['backbone/templates/marq/marq']

	className: 'container'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderQuestion')

	render: ->
		$(@el).html(@template())
		@collection.each(@renderQuestion)
		@
		
	renderQuestion: (question) ->
		view = new Ananta.Views.Marq.QuestionView({model : question})
		@$(".questions").prepend(view.render().el)