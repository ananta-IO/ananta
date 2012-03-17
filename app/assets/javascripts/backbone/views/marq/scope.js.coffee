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
		@$("a.info").popover
			placement: 'bottom'
			title: 'Scope'
			content: 'This is your current scope. Any question you ask will automatically be connected to the current page. Go to a different page to change the scope of your question.'
		@$("a.controller").tooltip
			placement: 'left'
			title: 'controller'	
		@$("a.action").tooltip
			placement: 'left'
			title: 'action'	
		@$("a.id").tooltip
			placement: 'left'
			title: 'id'	