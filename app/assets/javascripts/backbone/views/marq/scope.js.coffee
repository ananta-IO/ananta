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
			title: 'About Scope'
			content: 'This is your scope. Think of it as a filter based on the page you are visiting. Every question you ask will automatically be linked to your scope. Every question you answer <i>probably</i> pertains to your scope. Go to a different page to change your scope and the scope of the questions you ask and answer.'
		@$("a.controller").tooltip
			placement: 'right'
			title: 'controller'	
		@$("a.action").tooltip
			placement: 'right'
			title: 'action'	
		@$("a.id").tooltip
			placement: 'left'
			title: 'id'	