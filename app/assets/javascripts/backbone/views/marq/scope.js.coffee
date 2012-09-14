Ananta.Views.Marq ||= {}

class Ananta.Views.Marq.ScopeView extends Backbone.View
	template: JST['backbone/templates/marq/scope']

	className: 'span10 offset2'


	initialize: (options) ->
		_.bindAll(@, 'render')
		@session = new Ananta.Models.Session()
		@session.fetch()

		@session.bind('change', @render)

	render: ->
		$(@el).html(@template( @session.toJSON() ))
		@addPopovers()
		@

	addPopovers: ->
		@$("i.info").popover
			placement: 'bottom'
			title: 'About Scope'
			content: "This is your scope. A filter based on the current page. For example, this page: 
				<hr/><code>#{window.location.href}</code> 
				<hr/>has a scope of:
				<hr/><code>#{if @session.get('questionable_controller')? then @session.get('questionable_controller') else ''}#{if @session.get('questionable_action')? then '/' + @session.get('questionable_action') else ''}#{if @session.get('questionable_sid')? then '/' + @session.get('questionable_sid') else ''}</code>
				<hr/>Every question you ask will automatically be linked to this scope. Every question you answer will come from this scope. Go to a different page to change the scope of the questions you ask and answer."
		@$("a.controller").tooltip
			placement: 'right'
			title: 'controller'	
		@$("a.action").tooltip
			placement: 'right'
			title: 'action'	
		@$("a.id").tooltip
			placement: 'left'
			title: 'id'	