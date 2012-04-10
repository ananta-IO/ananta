Ananta.Views.Users ||= {}

class Ananta.Views.Users.LoginRegisterModal extends Backbone.View    
	template: JST["backbone/templates/users/login_register_modal"]

	className: 'modal fade'
	id: 'login_register_modal'

	events:
		'click .show-email a'		: 'expand'

	initialize: (options) ->
		_.bindAll(@, 'render')

	render: () ->
		$(@el).html(@template())
		$(@el).modal('show')
		@.$('.separator').hide()
		@.$('.email').hide()
		$('<p class="show-email"><a href="#">Don\'t have a Facebook account?</a></p>').insertAfter(@.$('.facebook'))

	expand: () ->
		@.$('.show-email').hide()
		@.$('.separator').slideDown()
		@.$('.email').slideDown()
		$(this.el).find(".string input").jLabel({color: "#999", yShift: '-2'})
		return false