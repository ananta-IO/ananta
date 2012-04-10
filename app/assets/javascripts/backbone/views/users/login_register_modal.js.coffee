Ananta.Views.Users ||= {}

class Ananta.Views.Users.LoginRegisterModal extends Backbone.View    
	template: JST["backbone/templates/users/login_register_modal"]

	className: 'modal fade'
	id: 'login_register_modal'

	initialize: (options) ->
		_.bindAll(@, 'render')

	render: () ->
		$(@el).html(@template())
		$(@el).modal('show')