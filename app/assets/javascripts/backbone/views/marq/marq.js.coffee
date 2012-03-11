Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.MarqView extends Backbone.View
	template: JST['backbone/templates/marq/marq']

	className: 'container'

	events:
		'keyup .ask input.question'              : 'questionCharCount'
		'change .ask input.question'             : 'questionCharCount'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderQuestion', 'questionCharCount', 'addPopovers')

	render: ->
		$(@el).html(@template())
		@questionCharCount()
		@addPopovers()
		@collection.each(@renderQuestion)
		@
		
	renderQuestion: (question) ->
		view = new Ananta.Views.Marq.QuestionView({model : question})
		@$(".questions").prepend(view.render().el)

	questionCharCount: ->
		count = @$(".ask input.question").val().length
		available = 140 - count
		@$(".ask .counter").html(available)

	addPopovers: ->
		@$(".ask .span2 h1").popover
			placement: 'bottom'
			title: 'About Ask'
			content: 'Ask a yes or no question in 140 characters or less. Your question should have something to do with the site in general or the current page you are on.'

		@$(".answer .span2 h1").popover
			placement: 'bottom'
			title: 'About Answer'
			content: 'Answer as many questions as you want. If you like, leave comments. Asking and answering questions is the quickest way to impact the features and direction of the site. Never stop questioning.'