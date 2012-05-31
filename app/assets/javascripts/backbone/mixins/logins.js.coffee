Ananta.Mixins.Logins =
	loginModal: (options) ->
        options or= {}
        options['message'] or= 'Would you like to continue?'
        view = new Ananta.Views.Users.LoginRegisterModal(options)
        view.render()
        return false