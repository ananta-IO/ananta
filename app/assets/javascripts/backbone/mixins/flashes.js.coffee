Ananta.Mixins.Flashes =
	renderFlashes: (messages, messageType, options) ->
		messages or= []
		messageType or= 'success'
		options or= {}
		options.parentSelector or= '.alerts'
		options.animateIn      or= true unless options.animateIn  == false 
		options.animateOut     or= true unless options.animateOut == false # only matters if amimateIn is true
		options.animationIn    or= 'fadeInLeft'
		options.animationOut   or= 'fadeOutRight'

		@clearFlashes(options.parentSelector)

		for message in messages
			@renderFlash(message, messageType, options.parentSelector)

		if options.animateIn then @animateFlashesIn(options)

	renderFlash: (message, messageType, selector) ->
		messageType or= 'success'
		selector or= '.alerts'
		@$(selector).append("<div class='alert alert-#{messageType}'><a class='close' data-dismiss='alert' href='#'>&times;</a>#{message}</div>")

	animateFlashesIn: (options) ->
		@$(".alert").css('visibility', 'hidden')
		@$(".alert").each (i, e) ->
			$(@).delay(i*300).queue () ->
				$(@).css('visibility', 'visible').addClass("animated #{options.animationIn}").dequeue()
				if options.animateOut then Ananta.Mixins.Flashes.animateFlashOut($(@), options.animationOut)
	
	animateFlashOut: (el, animation) ->
		wait 7000, =>
			el.addClass("animated #{animation}").delay(500).slideUp 700, =>
				wait 2000, =>
					el.remove()

	clearFlashes: (selector) ->
		@$(selector).html('')