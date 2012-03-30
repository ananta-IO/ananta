Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.ScopeView extends Backbone.View
	template: JST['backbone/templates/marq/scope']

	className: 'span10 offset2'


	initialize: (options) ->
		_.bindAll(@, 'render', 'addPopovers')
		@session =  new Ananta.Models.Session()
		@session.bind('change', @render)
		@session.fetch() 

	render: ->
		$(@el).html(@template( @session.toJSON() ))
		@addPopovers()
		@

	addPopovers: ->
		@$("i.info").popover
			placement: 'bottom'
			title: 'Scope'
			content: 'This is your current scope. Any question you ask will automatically be connected to your current scope. Go to a different page to change the scope of your question.'
		@$("a.controller").tooltip
			placement: 'right'
			title: 'controller'	
		@$("a.action").tooltip
			placement: 'right'
			title: 'action'	
		@$("a.id").tooltip
			placement: 'left'
			title: 'id'	