Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.MarqView extends Backbone.View
	template: JST['backbone/templates/marq/marq']

	className: 'container'

	events:
		'keyup .ask input.question'              : 'questionCharCount'
		'change .ask input.question'             : 'questionCharCount'
		'submit .ask form'                       : 'createQuestion'

	initialize: (options) ->
		_.bindAll(@, 'render', 'renderQuestions', 'renderQuestion', 'incrementCompleteness', 'questionCharCount', 'addPopovers', 'createQuestion', 'fetchQuestion')
		
		@collection.each(@incrementCompleteness)
		# @collection.comparator: (question) =>
		#   question.get('completeness')

		@collection.bind('add', @renderQuestion)
		@collection.bind('reset', @renderQuestions)
		@collection.bind('remove', @fetchQuestion)

	render: ->
		$(@el).html(@template())
		@questionCharCount()
		@addPopovers()

		scopeView = new Ananta.Views.Marq.ScopeView()
		@$(".scope").html(scopeView.render().el)

		@renderQuestions()

		@

	renderQuestions: ->
		if @collection.length > 0
			@$(".questions").html("")
			@collection.each(@renderQuestion)
		else
			@$(".questions").html("<div class='span5'><div class='question wrap'><div class='outer'><div class='inner'>You have answered every question. Ask some. Please ^_^</div></div></div></div>")
		
	renderQuestion: (question) ->
		view = new Ananta.Views.Marq.QuestionView({model : question})
		view.bind('fetchQuestion', @fetchQuestion)
		@$(".questions").prepend(view.render().el)

	incrementCompleteness: (question) ->
		c = question.get('completeness')
		new_c = if c then c + 1 else 0
		question.set('completeness', new_c)

	questionCharCount: ->
		count = @$(".ask input.question").val().length
		available = 140 - count
		@$(".ask .counter").html(available)

	addPopovers: ->
		@$(".ask .span2 h1").popover
			placement: 'bottom'
			title: 'Dying to know something?'
			content: 'Ask a yes or no question in 140 characters or less. Ask anything. Your questions and answers guide the evolution of this site.'

		@$(".answer .span2 h1").popover
			placement: 'bottom'
			title: 'answers &nbsp;<i class="icon-chevron-right"/>&nbsp;itteration'
			content: 'Answer as many questions as you want. Comments are optional. Asking and answering questions is the easiest way to impact the features and direction of this site.'

	createQuestion: (e) ->
		e.preventDefault()
		e.stopPropagation()

		question = new Ananta.Models.Question({question: @$(".ask input.question").val(), questionable_url: document.URL})
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
		@collection.fetch
			success: (collection) =>
				# @collection.reset(collection)

		if @collection.length <= 2
			return false #TODO
		else
			return false #TODO