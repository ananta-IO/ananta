Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.QuestionView extends Backbone.View
	template: JST['backbone/templates/marq/question']

	className: 'span5'

	events:
		'click textarea'                         		: 'stopPropagation'
		'click .btn-group.yes .state-event'      		: 'yes'
		'submit .btn-group.yes form'             		: 'yes'
		'click .btn-group.no .state-event'       		: 'no'
		'submit .btn-group.no form'              		: 'no'
		'click .btn-group.dont-care .state-event'		: 'dontCare'
		'submit .btn-group.dont-care form'       		: 'dontCare'


	initialize: (options) ->
		_.bindAll(@, 'render', 'stopPropagation', 'yes', 'no', 'dontCare', 'saveAnswer')
		@answer = new Ananta.Models.Answer
		@answer.urlRoot = "/questions/#{@model.id}/answers"
		@answer.bind('')

	render: ->
		$(@el).html(@template( @model.toJSON() ))
		@

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
				@$(".actions").html("#{state_event}!")	
			error: (data, jqXHR) =>
				# @answer.set({errors: $.parseJSON(jqXHR.responseText)})
				# @render()	
		)
