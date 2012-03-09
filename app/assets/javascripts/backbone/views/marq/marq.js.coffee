Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.MarqView extends Backbone.View
	template: JST['backbone/templates/marq/marq']

	className: 'container'

	initialize: (options) ->
		_.bindAll(@, 'render', 'addAllQuestions', 'addQuestion')
		@questions = options.questions

	render: ->
		console.log @el
		$(@el).html(@template( questions: @questions.toJSON() ))
		@addAllQuestions()
		@

	addAllQuestions: ->
		@questions.each(@addQuestion)

	addQuestion: (question) ->
		view = new Ananta.Views.Question.MiniQuestionView({model : question})
		@$("#questions").prepend(view.render().el)