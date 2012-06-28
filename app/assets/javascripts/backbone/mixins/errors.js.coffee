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

		@clearErrors(options.parentSelector)

		if errors['error'] then @renderError(errors['error'], '', options.parentSelector)
		if errors['error'] == "You need to sign in or sign up before continuing." then @loginModal(options.loginCallback)
		if errors['errors']
			for key, val of errors['errors']
				if options.keysToRender? and (options.keysToRender.some (word) -> word == key)
					@renderError(val, key, options.parentSelector)
				else
					@renderError(val, key, options.parentSelector)

		if options.animateIn then @animateErrorsIn(options)

		Analytical.event('Render Errors', { with: { location: window.location.href, errors: errors, options: options } } )

	renderError: (error, attribute, selector) ->
		attribute or= ''
		if error == 'Invalid email or password.' then error = 'Invalid password.' # Special case for login_register_modal. Maybe refactor our of here?
		render = (e, a) => @$(selector).append("<div class='alert alert-error'><a class='close' data-dismiss='alert' href='#'>&times;</a>#{a} #{e}</div>")
		if typeof error == 'string'
			render(error, attribute)
		else
			_.each error, (error) ->
				render(error, attribute)

	animateErrorsIn: (options) ->
		@$(".alert").css('visibility', 'hidden')
		@$(".alert").each (i, e) ->
			$(@).delay(i*300).queue () ->
				$(@).css('visibility', 'visible').addClass("animated #{options.animationIn}").dequeue()
				if options.animateOut then Ananta.Mixins.Errors.animateErrorOut($(@), options.animationOut)
	
	animateErrorOut: (el, animation) ->
		wait 7000, =>
			el.addClass("animated #{animation}").delay(500).slideUp 700, =>
				wait 2000, =>
					el.remove()

	clearErrors: (selector) ->
		@$(selector).html('')

Ananta.Mixins.Errors = $.extend(Ananta.Mixins.Errors, Ananta.Mixins.Logins)