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
		data.addColumn "string", "Answer"
		data.addColumn "number", "Count"
		data.addRows [ [ "Yes", @model.get('yes_count') ], [ "No", @model.get('no_count') ], [ "Dont' Care", @model.get('dont_care_count') ] ]
		options =
			width: 175
			height: 107
			# colors: ['#d6e9c6', '#eed3d7', '#fbeed5']
			colors: ['#5bb65b', '#da4e49', '#999999'] 

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
		$.ajax 
			type: 'PUT'
			dataType: "json"
			url: "/questions/#{@model.id}"
			data: {question: {cast_vote: {vote: vote}}}  
			success: (data) => 
				@model.set(data)
				@render()
				wait 300, =>
					@collection.remove(@model)
					@.trigger('removeQuestion')
			error: =>