Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.MarqView extends Backbone.View
	template: JST['backbone/templates/marq/marq']

	className: 'container'

	events:
		'keyup .ask input.question'              : 'questionCharCount'
		'change .ask input.question'             : 'questionCharCount'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderQuestion')

	render: ->
		$(@el).html(@template())
		@collection.each(@renderQuestion)
		@
		
	renderQuestion: (question) ->
		view = new Ananta.Views.Marq.QuestionView({model : question})
		@$(".questions").prepend(view.render().el)

	questionCharCount: ->
		count = @$(".ask input.question").val().length
		available = 140 - count
		@$(".ask .counter").html(available)