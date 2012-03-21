Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.VoteView extends Backbone.View
	template: JST['backbone/templates/marq/vote']

	className: 'vote'

	events:
		'click .up'  		: 'up'
		'click .down'		: 'down'


	initialize: (options) ->
		_.bindAll(@, 'render', 'renderPieChart', 'up', 'down', 'saveVote')

	render: ->
		$(@el).html(@template( @model.toJSON() ))
		wait 300, =>
			@renderPieChart()
		@

	renderPieChart: ->
		data = new google.visualization.DataTable()
		console.log data
		data.addColumn "string", "Answer"
		data.addColumn "number", "Count"
		data.addRows [ [ "Yes", @model.get('yes_count') ], [ "No", @model.get('no_count') ], [ "Dont' Care", @model.get('dont_care_count') ] ]
		options =
			width: 200
			height: 107

		chart = new google.visualization.PieChart(document.getElementById("marq_pie_#{@model.id}"))
		chart.draw data, options		

	up: (e) ->
		@saveVote('for')
		e.preventDefault()
		e.stopPropagation()

	down: (e) ->
		@saveVote('against')
		e.preventDefault()
		e.stopPropagation()

	saveVote: (vote) ->
		@model.toJSON(
			{cast_vote: {vote: vote}}
			# success: (data) =>
			#	@$(".actions").html("#{vote}!")
			# error: (data, jqXHR) =>
				# @answer.set({errors: $.parseJSON(jqXHR.responseText)})
				# @render()	
		)