Ananta.Mixins.Logins =
	loginModal: (options) ->
		options or= {}
		options['callback'] or= -> 
			console.log 'logged in'
			$.getScript("/render_nav")
		options['message'] or= 'To continue'
		window.loginModal = new Ananta.Views.Users.LoginRegisterModal(options)
		window.loginModal.render()
		return false