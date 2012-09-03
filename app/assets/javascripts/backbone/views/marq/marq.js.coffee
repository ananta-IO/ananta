Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.MarqView extends Backbone.View
	template: JST['backbone/templates/marq/marq']

	className: 'container'

	events:
		'keyup .ask input.question'              : 'questionCharCount'
		'change .ask input.question'             : 'questionCharCount'
		'submit .ask form'                       : 'createQuestion'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderQuestions', 'renderQuestion', 'renderErrors', 'createQuestion', 'fetchQuestion')
		@fetchQuestion()

		@collection.bind('add', @renderQuestion)
		@collection.bind('reset', @renderQuestions)
		@views = []

	render: ->
		$(@el).html(@template())
		
		@questionCharCount()
		@addPopovers()

		scopeView = new Ananta.Views.Marq.ScopeView()
		@views.push(scopeView)
		@$(".scope").html(scopeView.render().el)

		@renderQuestions()

		@

	renderQuestions: ->
		@$(".questions tr").html("")
		if @collection.length > 0
			@collection.each(@renderQuestion)
		else
			@noMoreQuestions()
			
	renderQuestion: (question) ->
		view = new Ananta.Views.Marq.QuestionView({model : question, collection : @collection})
		@views.push(view)
		view.bind('fetchQuestion', @fetchQuestion)
		view.bind('renderErrors', @renderErrors)
		v = $(view.render().el)
		@$(".questions tr").prepend(v)
		v.addClass('animated fadeInDown')
		@$('.nmqs').remove()

	clearErrors: ->
		@$(".alerts .span10").html('')

	questionCharCount: ->
		count = @$(".ask input.question").val().length
		available = 140 - count
		@$(".ask .counter").html(available)

	addPopovers: ->
		@$(".ask .span2 h1").popover
			placement: 'bottom'
			title: 'About Ask'
			content: 'Ask a yes or no question in 140 characters or less. Ask anything. Every question is tied to the page it was asked on. Please try to ask questions relevant to the current page. Thanks for asking.'

		@$(".answer .span2 h1").popover
			placement: 'bottom'
			title: 'About Answer'
			content: 'Answering questions is the easiest way to impact this site and the projects grown in it. Answer as many questions as you want. Comments are optional. The questions on every page are unique. Go to a different page to see the questions asked on it.'

		@$(".tldr").popover
			placement: 'bottom'
			delay: { show: 0, hide: 2000 }
			title: "About Marq"
			content: "This is Marq. Marq is a tool for getting and giving quick feedback. Ananta IO is open source software designed to host your projects. You have a stake in this software. You have a stake in these projects. And you should be able to quickly and enjoyably impact the evolution of this software and the projects grown in it. Anyone can look at the <a href='https://github.com/ananta-io/ananta' target='_blank'>source code</a> and submit changes to it. But if you just want a lot of quick feedback on a specific page, project, bug, feature or idea; go ahead and ask your question with Marq."

	createQuestion: (e) ->
		e.preventDefault()
		e.stopPropagation()

		question = new Ananta.Models.Question({ question: @$(".ask input.question").val(), questionable_url: window.location.href })
		question.save(null
			success: (data) =>
				Analytical.event('Marq - Successfully ask a question', { question: data.get('question'), location: window.location.href } )
				@$(".ask input.question").val('')
				@questionCharCount()
				@clearErrors()
				@collection.add(data)
			error: (data, jqXHR) =>
				errors = $.parseJSON(jqXHR.responseText)
				Analytical.event('Marq - Unsuccessfully ask a question', { error: JSON.stringify(errors), question: data.get('question'), location: window.location.href } )
				@renderErrors errors,
					parentSelector : '.alerts .span10'
					keysToRender   : ['question']
					animateIn      : true
					animateOut     : true
					animationIn    : 'fadeInDown'
					animationOut   : 'fadeOutUp'
					loginCallback  : null
		)

	fetchQuestion: ->
		l = @collection.length
		# Only fetch a question if all questions have been answered
		if l == @collection.justAnswered().size()
			@collection.fetch
				add: true
				success: (collection) =>
					# If no question could be fetched then all questions are answered
					if collection.length == l
						@noMoreQuestions()
					else
						wait 200, () =>
							@$('.nmqs').remove()

	noMoreQuestions: ->
		@$('.nmqs').remove()
		@$(".questions tr").prepend("<td class='nmqs'><div class='span5'><div class='question wrap'><div class='outer'><div class='inner'>You have answered every question on this page. Why don't you ask a question. Or <a href='/questions/random_unanswered'>go to a different page</a> and answer more questions.</div></div></div></div></td>")

	onClose: ->
		for view in @views
			view.close()


_.extend(Ananta.Views.Marq.MarqView::, Ananta.Mixins.Errors)