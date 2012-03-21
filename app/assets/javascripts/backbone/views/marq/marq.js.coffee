Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.MarqView extends Backbone.View
	template: JST['backbone/templates/marq/marq']

	className: 'container'

	events:
		'keyup .ask input.question'              : 'questionCharCount'
		'change .ask input.question'             : 'questionCharCount'
		'submit .ask form'                       : 'createQuestion'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderQuestions', 'renderQuestion', 'questionCharCount', 'addPopovers', 'createQuestion', 'fetchQuestion', 'updateAnsScrollBar')

		@collection.bind('add', @renderQuestion)
		@collection.bind('reset', @renderQuestions)
		@collection.bind('remove', @fetchQuestion)
		
		# $(window).bind('resize', @updateAnsScrollBar)

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
			@$(".questions tr").html("<div class='span5'><div class='question wrap'><div class='outer'><div class='inner'>You have answered every question. Ask some. Please ^_^</div></div></div></div>")
		
	renderQuestion: (question) ->
		view = new Ananta.Views.Marq.QuestionView({model : question})
		view.bind('fetchQuestion', @fetchQuestion)
		@$(".questions tr").prepend(view.render().el)
		@$(".questions tr td").first().hide()
		@$(".questions tr td").first().show("slide", { direction: "left" }, 500)

		# update the scroll bar
		@updateAnsScrollBar()

	questionCharCount: ->
		count = @$(".ask input.question").val().length
		available = 140 - count
		@$(".ask .counter").html(available)

	addPopovers: ->
		@$(".ask .span2 h1").popover
			placement: 'bottom'
			title: 'Dying to know something?'
			content: 'Ask a yes or no question in 140 characters or less. Ask anything. Your questions guide the evolution of this site and the projects on it.'

		@$(".answer .span2 h1").popover
			placement: 'bottom'
			title: 'answers &nbsp;<i class="icon-chevron-right"/>&nbsp;itteration'
			content: 'Answer as many questions as you want. Comments are optional. Answering questions is the easiest way to impact this site and the projects on it.'

	createQuestion: (e) ->
		e.preventDefault()
		e.stopPropagation()

		question = new Ananta.Models.Question({ question: @$(".ask input.question").val() })
		question.save(null
			success: (data) =>
				@$(".ask input.question").val('')
				@questionCharCount()
				@collection.add(data)
			error: (data, jqXHR) =>
				# question.set({errors: $.parseJSON(jqXHR.responseText)})
				# @render()
		)

	fetchQuestion: ->
		@collection.fetch({add: true})

	updateAnsScrollBar: ->
		$('#marq .answer .span10').jScrollPane()	

