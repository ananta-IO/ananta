Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.MarqView extends Backbone.View
	template: JST['backbone/templates/marq/marq']

	className: 'container'

	events:
		'keyup .ask input.question'              : 'questionCharCount'
		'change .ask input.question'             : 'questionCharCount'
		'submit .ask form'                       : 'createQuestion'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderQuestions', 'renderQuestion', 'renderErrors', 'clearErrors', 'questionCharCount', 'addPopovers', 'createQuestion', 'fetchQuestion', 'updateAnsScrollBar', 'noMoreQuestions')

		@collection.bind('add', @renderQuestion)
		@collection.bind('reset', @renderQuestions)

	render: ->
		# render the hamlc template
		$(@el).html(@template())
		
		@questionCharCount()
		@addPopovers()

		scopeView = new Ananta.Views.Marq.ScopeView()
		@$(".scope").html(scopeView.render().el)

		@renderQuestions()

		@

	renderQuestions: ->
		if @collection.length > 0
			# render the question(s)
			@$(".questions tr").html("")
			@collection.each(@renderQuestion)
		else
			# render "you've answered them all hon :)"
			@noMoreQuestions()
			
	renderQuestion: (question) ->
		view = new Ananta.Views.Marq.QuestionView({model : question, collection : @collection})
		view.bind('fetchQuestion', @fetchQuestion)
		view.bind('renderErrors', @renderErrors)
		@$(".questions tr").prepend(view.render().el)
		# Update the scroll bar
		@updateAnsScrollBar()
		# If inside scrollbar then add absolute positioning    # TODO: figure out if absolute positioning can be added before the scrollbar wrapper 
		if @collection.length == 2 then @$(".questions").css({'position':'absolute'})
		# Animate the transition
		@$(".questions").css({'left':'-496px'})
		@$(".questions").animate({"left":"0px"}, 1000)

	renderErrors: (errors) ->
		@clearErrors()
		if errors['error'] then @$(".alerts .span10").append("<div class='alert alert-error'><a class='close' data-dismiss='alert' href='#'>&times;</a>#{errors['error']}</div>")
		if errors['errors']
			if errors['errors']['question']
				_.each(errors['errors']['question'], (error) ->
					@$(".alerts .span10").append("<div class='alert alert-error'><a class='close' data-dismiss='alert' href='#'>&times;</a>question #{error}</div>")
				)
			if errors['errors']['answer']
				_.each(errors['errors']['answer'], (error) ->
					@$(".alerts .span10").append("<div class='alert alert-error'><a class='close' data-dismiss='alert' href='#'>&times;</a>answer #{error}</div>")
				)
		@$('.alert').hide()
		@$('.alert').show('fade', {}, 800)
		@$('.alert').delay(10000).hide('fade', {}, 800)

	clearErrors: ->
		@$(".alerts .span10").html('')

	questionCharCount: ->
		count = @$(".ask input.question").val().length
		available = 140 - count
		@$(".ask .counter").html(available)

	addPopovers: ->
		@$(".ask .span2 h1").popover
			placement: 'bottom'
			title: 'Want to know something?'
			content: 'Ask a yes or no question in 140 characters or less. Ask anything. Each question is tied to the page it was asked on. Please try to ask questions relevant to the current page. Thanks for asking.'

		@$(".answer .span2 h1").popover
			placement: 'bottom'
			title: 'Answers &nbsp;<i class="icon-chevron-right"/>&nbsp;Iteration'
			content: 'Answering questions is the easiest way to impact this site and the projects on it. Answer as many questions as you want. Comments are optional. The questions on every page are unique. Go to a different page to see the questions asked on it.'

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
				@renderErrors($.parseJSON(jqXHR.responseText))
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
						@updateAnsScrollBar()

	updateAnsScrollBar: ->
		$('#marq .answer .span10').jScrollPane()	

	noMoreQuestions: ->
		@$(".questions tr").prepend("<td><div class='span5'><div class='question wrap'><div class='outer'><div class='inner'>You have answered every question on this page. Why don't you go outside and take a break... Or go to a different page and answer more questions.</div></div></div></div></td>")

