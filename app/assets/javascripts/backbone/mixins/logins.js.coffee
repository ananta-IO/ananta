Ananta.Mixins.Logins =
	loginModal: (options) ->
        options or= {}
        options['message'] or= 'login or register to continue'
        options['callback'] or= ->
            window.location = '/'
        view = new Ananta.Views.Users.LoginRegisterModal(options)
        view.render()
        return false