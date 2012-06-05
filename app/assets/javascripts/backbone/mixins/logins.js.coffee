Ananta.Mixins.Logins =
	loginModal: (options) ->
		options or= {}
		options['callback'] or= -> 
			console.log 'logged in'
			$.ajax { type: 'POST', url: "/render_nav" }
		options['message'] or= 'To continue'
		view = new Ananta.Views.Users.LoginRegisterModal(options)
		view.render()
		return false