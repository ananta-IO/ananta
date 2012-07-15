Ananta.Mixins.Errors =
	renderErrors: (errors, options) ->
		errors  or= {}
		options or= {}
		options.parentSelector or= '.alerts'
		options.keysToRender   or= null
		options.animateIn      or= true unless options.animateIn  == false 
		options.animateOut     or= true unless options.animateOut == false # only matters if amimateIn is true
		options.animationIn    or= 'fadeInLeft'
		options.animationOut   or= 'fadeOutRight'
		options.loginCallback  or= null # i.e. whatever the default is

		messages = []

		if errors['error'] then messages = @parseError(errors['error'], '', messages)
		if errors['error'] == "You need to sign in or sign up before continuing." then @loginModal(options.loginCallback)
		if errors['errors']
			for key, val of errors['errors']
				if options.keysToRender? and (options.keysToRender.some (word) -> word == key)
					messages = @parseError(val, key, messages)
				else
					messages = @parseError(val, key, messages)

		@renderFlashes(messages, 'error', options)

	parseError: (error, attribute, messages) ->
		attribute or= ''
		messages or= []
		Analytical.event('Render Error', { error: error, attribute: attribute, location: window.location.href } )

		if error == 'Invalid email or password.' then error = 'Invalid password.' # Special case for login_register_modal. Maybe refactor out of here?
		
		switch attribute
			when 'friendly_id' then attribute = 'phrase'

		format = (e, a) -> 
			"#{a} #{e}"
			
		if typeof error == 'string'
			messages.add format(error, attribute)
		else
			_.each error, (error) ->
				messages.add format(error, attribute)

		messages

Ananta.Mixins.Errors = $.extend(Ananta.Mixins.Errors, Ananta.Mixins.Flashes)
Ananta.Mixins.Errors = $.extend(Ananta.Mixins.Errors, Ananta.Mixins.Logins)