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

	renderErrors: (errors) ->
		@clearErrors()
		if errors['error'] then @renderError(errors['error'])
		if errors['errors']
			for key, val of errors['errors']
				if (['question', 'answer'].some (word) -> word == key)
					@renderError(val, key)
		@$('.alert').addClass('animated fadeInDown')
		wait 7000, () =>
			@$('.alert').addClass('animated fadeOutUp').delay(500).slideUp(500)

	renderError: (error, attribute) ->
		attribute or= ''
		render = (e, a) => @$(".alerts .span10").append("<div class='alert alert-error'><a class='close' data-dismiss='alert' href='#'>&times;</a>#{a} #{e}</div>")
		if typeof error == 'string'
			render(error, attribute)
		else
			_.each error, (error) ->
				render(error, attribute)

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
			content: "This questionably large dropdown is named Marq. Marq is a tool for getting and giving quick feedback. Ananta IO is open source software designed to host your projects. You own this software. You own these projects. And you should be able to quickly and enjoyably impact the evolution of this software and the projects grown in it. Anyone can look at the <a href='https://github.com/ananta-io/ananta' target='_blank'>source code</a> and make changes to it. But if you just want a lot of quick feedback on a specific page, project, bug, feature or idea; go ahead and ask your question here."

	createQuestion: (e) ->
		e.preventDefault()
		e.stopPropagation()

		question = new Ananta.Models.Question({ question: @$(".ask input.question").val() })
		question.save(null
			success: (data) =>
				@$(".ask input.question").val('')
				@questionCharCount()
				@clearErrors()
				@collection.add(data)
			error: (data, jqXHR) =>
				errors = $.parseJSON(jqXHR.responseText)
				@renderErrors(errors)
				if errors['error'] == "You need to sign in or sign up before continuing."
					@loginModal()
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
		url = '/projects'
		render = (url) => @$(".questions tr").prepend("<td class='nmqs'><div class='span5'><div class='question wrap'><div class='outer'><div class='inner'>You have answered every question on this page. Why don't you ask a question. Or <a href='#{url}'>go to a different page</a> and answer more questions.</div></div></div></div></td>")
		$.ajax(
			dataType  : 'json'
			type      : 'GET'
			url       : url
			data      : {order:'r', per:1}
			success: (data) =>
				if data[0]? then url = data[0]['url']
				@$('.nmqs').remove()
				render url
			error: () =>
				@$('.nmqs').remove()
				render url
		)

	onClose: ->
		for view in @views
			view.close()


_.extend(Ananta.Views.Marq.MarqView::, Ananta.Mixins.Logins)