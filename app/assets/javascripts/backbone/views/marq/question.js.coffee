Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.QuestionView extends Backbone.View
	template: JST['backbone/templates/marq/question']

	tagName: 'td'

	events:
		'click .dropdown-toggle'                        : 'focusForm'
		'click textarea'                                : 'stopPropagation'
		'click .btn-group.yes .state-event'             : 'yes'
		'submit .btn-group.yes form'                    : 'yes'
		'click .btn-group.no .state-event'              : 'no'
		'submit .btn-group.no form'                     : 'no'
		'click .btn-group.dont-care .state-event'       : 'dontCare'
		'submit .btn-group.dont-care form'              : 'dontCare'


	initialize: (options) ->
		_.bindAll(@, 'render', 'addPopovers', 'focusForm', 'stopPropagation', 'yes', 'no', 'dontCare', 'saveAnswer', 'removeQuestion')
		@answer = new Ananta.Models.Answer
		@answer.urlRoot = "/questions/#{@model.id}/answers"
		@answer.bind('')

	render: ->
		$(@el).html(@template( @model.toJSON() ))
		@addPopovers()
		@

	addPopovers: ->
		@$(".string").tooltip
			placement: 'bottom'
			title: "Scope &middot; #{@model.get('questionable_controller')} / #{@model.get('questionable_action')} #{if @model.get('questionable_sid') then '/ ' + @model.get('questionable_sid') else ''}"

	focusForm: ->
		wait 100, ->
			$('.btn-group textarea:enabled:visible:first').focus()

	stopPropagation: (e) ->
		e.stopPropagation()

	yes: (e) ->
		@saveAnswer('yes', @$(".btn-group.yes textarea").val())
		e.preventDefault()
		e.stopPropagation()

	no: (e) ->
		@saveAnswer('no', @$(".btn-group.no textarea").val())
		e.preventDefault()
		e.stopPropagation()

	dontCare: (e) ->
		@saveAnswer('dont_care', @$(".btn-group.dont-care textarea").val())
		e.preventDefault()
		e.stopPropagation()

	saveAnswer: (state_event, comment) ->
		@answer.save(
			{state_event: "ans_#{state_event}", comment: comment}
			success: (data) =>  
				# add the data from the server to the question
				@model.set(data['attributes']['question'])
				@model.set('just_answered', true)
				# add the vote view
				voteView = new Ananta.Views.Marq.VoteView({model: @model, collection: @collection})
				voteView.bind('removeQuestion', @removeQuestion)
				@$(".inner").html(voteView.render().el)
				# fetch a new question
				@.trigger('fetchQuestion')
			error: (data, jqXHR) =>
				@.trigger( 'renderErrors', $.parseJSON(jqXHR.responseText) ) 
		)

	removeQuestion: ->
		@remove()
