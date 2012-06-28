Ananta.Mixins.Logins =
	loginModal: (options) ->
		Analytical.event('Programmatically Open Login Modal', { with: { location: window.location.href } } )
		options or= {}
		options['callback'] or= -> 
			console.log 'logged in'
			$.getScript("/render_nav")
		options['message'] or= 'To continue'
		window.loginModal = new Ananta.Views.Users.LoginRegisterModal(options)
		window.loginModal.render()
		return false