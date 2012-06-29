Ananta.Views.Users ||= {}

class Ananta.Views.Users.LoginRegisterModal extends Backbone.View    
	template: JST["backbone/templates/users/login_register_modal"]

	className: 'modal fade'
	id: 'login_register_modal'

	events:
		'click .fb-login-button'   		: 'facebookLogin'
		'click #login-action'      		: 'login'
		'click .show-email a'      		: 'expand'
		'focus #login-password'    		: 'passwordFocus'
		'blur #login-password'     		: 'passwordBlur'
		'blur #login-email'        		: 'checkEmail'
		'click .mailcheck a.domain'		: 'acceptSuggestion'
		'keyup #login-password'    		: 'checkPassword'
		'keyup #login-username'    		: 'checkUsername'
		'keyup #project-name'      		: 'checkProjectName'
		'shown'                    		: 'renderWhenReady'
		'hidden'                   		: 'cleanUp'

	initialize: (options) ->
		_.bindAll(@, 'render', 'cleanUp')
		options or= {}
		Ananta.App.currentUser or= new Ananta.Models.User()
		@user = new Ananta.Models.User( options.user )
		@callback = options.callback or= ->
			window.location = window.location
		@message = options.message
		@register = false
		@username_pattern = /^[A-Za-z-]*$/i
		@email_pattern = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
		@checkUser()
		@mailcheckDomains = [
			'ananta.io'
			'att.net'
			'comcast.net'
			'facebook.com'
			'gmail.com'
			'gmx.com'
			'google.com'
			'googlemail.com'
			'hotmail.co.uk'
			'hotmail.com'
			'live.com'
			'mac.com'
			'mail.com'
			'me.com, aol.com'
			'msn.com'
			'sbcglobal.net'
			'verizon.net'
			'yahoo.co.uk'
			'yahoo.com'
		]

	checkUser: ->
		if @user.get('id') == null
			@register = true

	render: ->
		$('#login_register_modal').remove()

		$(@el).html(@template( @user.toJSON() )).modal('keyboard': true, 'backdrop': true)
		@delegateEvents()
		$(@el).modal('show')

		@addCSRF()
		if @message then @addMessage()
		@$('label').hide()

		unless @register
			@$('#login-email').attr('name', 'user[login]')
			@$('form').attr('action', '/users/sign_in')
			@$('.separator').hide()
			@$('.email').hide()
			@$('.username').remove()
			@$('.project-name').remove()
			$('<p class="show-email"><a href="#">Don\'t have a Facebook account?</a></p>').insertAfter(@$('.facebook'))

		@

	renderWhenReady: ->
		if @register
			@checkEmail()
			@checkUsername()
			@$('.forgot-password').hide()
			@$('.separator span').hide()
			@addJLabel(".string input")
			@$('#login-password').focus()
			@$('.facebook img').tooltip({ placement:'bottom', title:'finish registration <i class="icon-arrow-down" />' }).tooltip('show')
		else
			@$('.fb-login-button').focus()
	
	expand: (e) ->
		@$('#login-action').hide()
		@$('.show-email').hide()
		@$('.separator').slideDown()
		@$('.email').slideDown () =>
			@addJLabel(".string input")
			@$('#login-email').focus()
		Analytical.event('Login Modal - Click To Expand Login Form', { message: @message, location: window.location.href } )
		e.preventDefault()
		e.stopPropagation()

	passwordFocus: ->
		@$('.forgot-password').fadeOut(500)

	passwordBlur: ->
		if @$('#login-password').val() == '' and @register == false
			@$('.forgot-password').fadeIn(500)

	checkEmail: ->
		if @$('#login-email').val().toLowerCase() != @email and @$('#login-email').val() != ''
			@email = @$('#login-email').val().toLowerCase()
			@$('.login-email i.hint').tooltip('hide').remove()
			$('.mailcheck').css('display', 'none').empty();
			@$('#login-email').attr('disabled', 'disabled').after('<img src="/assets/ajax-loader-black-dots.gif" class="loader" />')
			space_pattern = /\s/

			if(@email_pattern.test(@email) && space_pattern.test(@email) == false)
				$.ajax
					dataType : 'json'
					type : 'GET'
					url : '/users'
					data :
						email : @email
					success: (data) =>
						@$('.email .loader').remove()
						@$('#login-email').removeAttr('disabled')
						@$('#login-password').focus()
						if data.length > 0
							@displayLogin()
						else
							@displayRegister()

			else if(@username_pattern.test(@email))
				$.ajax
					dataType : 'json'
					type : 'GET'
					url : '/users'
					data :
						username : @email
					success: (data) =>
						@$('.email .loader').remove()
						@$('#login-email').removeAttr('disabled')
						@$('#login-password').focus()
						if data.length > 0
							@displayLogin()
						else
							@$('#login-email').after('<i class="hint icon-remove" />')
							@$('.login-email i.hint').tooltip({placement: 'top', title: "that's not an email"}).tooltip('show')

			else
				@$('.email .loader').remove()
				@$('#login-email').removeAttr('disabled').after('<i class="hint icon-remove" />')
				@$('.login-email i.hint').tooltip({placement: 'top', title: "that's not an email"}).tooltip('show')
				@$('#login-email').focus()
	
	mailcheck: ->
		$('#login-email').mailcheck
			domains: @mailcheckDomains
			suggested: (e, suggestion) =>
				hint = "Did you mean <span class='suggestion'>" +
					"<span class='address'>" + suggestion.address + "</span>" +
					"@<a href='#' class='domain'>" + suggestion.domain + 
					"</a></span>?"             
				$('.mailcheck').html(hint).fadeIn(150)
			empty: (e) =>
				$('.mailcheck').css('display', 'none').empty()

	acceptSuggestion: (e) ->
		$('#login-email').val($('.login-email .mailcheck .suggestion').text())
		$('.login-email .mailcheck').css('display', 'none').empty()
		@checkEmail()
		e.preventDefault()
		e.stopPropagation()

	checkPassword: ->
		min_l = 8
		secure_l = 20
		@password = @$('#login-password').val()
		@$('.password .hint.error').tooltip('hide').remove()
		if @password != ''
			if @password.length < min_l
				@$('.password .hint.success').remove()
				@$('#login-password').after('<i class="hint icon-remove error" />')
				@$('.password i.hint.error').tooltip({placement: 'top', title: "must be 8 or more characters"}).tooltip('show')
			else
				if @$('.password .hint.success').length == 0 then @$('#login-password').after('<i class="hint icon-ok success" /> <i class="hint icon-ok success mod" />')
				alpha = (secure_l - @password.length) / (secure_l - min_l)
				color = $.Color("rgba(255, 222, 0, #{if alpha < 0 then 0 else alpha})")
				@$('.password .hint.mod').animate({'color': color}, 100)

	checkUsername: ->
		@username = @$('#login-username').val()
		@$('.username i.hint').tooltip('hide').remove()
		if @username != ''
			@$('#login-username').after('<img src="/assets/ajax-loader-black-dots.gif" class="loader" />')
			if @username.length < 3
				@$('.username .loader').remove()
				@$('#login-username').after('<i class="hint icon-remove" />')
				@$('.username i.hint').tooltip({placement: 'top', title: "must be 3 or more letters"}).tooltip('show')
			else if !@username_pattern.test(@username)
				@$('.username .loader').remove()
				@$('#login-username').after('<i class="hint icon-remove" />')
				@$('.username i.hint').tooltip({placement: 'top', title: "letters and hyphens only"}).tooltip('show')
			else
				$.ajax
					dataType : 'json'
					type : 'GET'
					url : '/users'
					data :
						username : @username
					success: (data) =>
						@$('.username .loader').remove()				
						if data.length == 0
							@$('#login-username').after('<i class="hint icon-ok" />')		
						else
							@$('#login-username').after('<i class="hint icon-remove" />')
							@$('.username i.hint').tooltip({placement: 'top', title: "taken"}).tooltip('show')

	checkProjectName: ->
		min_l = 3
		max_l = 141
		@projectName = @$('#project-name').val()
		@$('.project-name i.hint').tooltip('hide').remove()
		if @projectName != ''
			if @projectName.length < min_l or @projectName.length > max_l
				@$('.project-name .hint.success').remove()
				@$('#project-name').after('<i class="hint icon-remove error" />')
				if @projectName.length < min_l
					@$('.project-name i.hint.error').tooltip({placement: 'top', title: "must be 3 or more characters"}).tooltip('show')
				else if @projectName.length > max_l
					@$('.project-name i.hint.error').tooltip({placement: 'top', title: "must be 141 or fewer characters"}).tooltip('show')
			else
				@$('#project-name').after('<i class="hint icon-ok" />')

	facebookLogin: (e) ->
		e.preventDefault()
		e.stopPropagation()

		@cleanUp()
		@$('.fb-login-button img').addClass('rideSpinners')

		callback = (response) =>
			$.ajax
				dataType  : 'json'
				url       : "/users/auth/facebook/callback"
				success: (data) =>
					user = data
					Ananta.App.currentUser.set(user)
					if user["id"]?
						@callback()
						@close()
					else
						if window.loginModal
							window.loginModal.close()
						window.loginModal = new Ananta.Views.Users.LoginRegisterModal(
							callback: @callback
							user: user
						)
						window.loginModal.render()

		fbLogin(callback)
		
		Analytical.event('Login Modal - Click Facebook', { message: @message, location: window.location.href, register: @register } )

	login: (e) ->
		e.preventDefault()
		e.stopPropagation()

		@renderLoginSpinner()
		$form = @$('form')
		data = $form.serializeArray()
		if Ananta.App.currentProject and Ananta.App.currentProject.get('tag_tokens') then data.add({ name:'project[tag_tokens]', value: Ananta.App.currentProject.get('tag_tokens') })
		$.ajax(
			dataType  : 'json'
			type      : 'POST'
			url       : $form.attr('action')
			data      : data
			success: (data) =>
				user = data
				Ananta.App.currentUser.set(user)
				@callback()
				@close()
			error: (data) =>
				@cleanUp()
				errors = $.parseJSON(data.responseText)
				@renderErrors errors,
					keysToRender   : ['email', 'password', 'username']
					loginCallback  : null
		)

		Analytical.event('Login Modal - Click Login', { message: @message, location: window.location.href, register: @register } )

	addJLabel: (element) ->
		$(@el).find(element).jLabel({color: "#acacac", opacity: 0.8, yShift: '-2'})
		$(@el).find(element).click ->
			$(@).parent().find('input').focus()

	addCSRF: ->
		authenticity_token = $("<div style='margin:0;padding:0;display:inline'><input name='utf8' type='hidden' value='✓'><input name='authenticity_token' type='hidden' value='#{$('meta[name="csrf-token"]').attr('content')}'></div>")
		@$('form').prepend(authenticity_token)

	renderLoginSpinner: ->
		@$('#login-action').after '<img src="/assets/ajax-loader-black-dots.gif" class="loader" />'

	clearLoginSpinner: ->
		@$('.email img.loader').remove()

	displayLogin: ->
		@register = false
		@$('#login-email').attr('name', 'user[login]').after('<i class="hint icon-ok" />')
		@$('form').attr('action', '/users/sign_in')
		@$('#login-action').html("Log in").show()
		if !@$('#login-password').is(':focus') then @$('.forgot-password').fadeIn(500)
		@$('.username').slideUp () => 
			@$('.username').remove()
		@$('.project-name').slideUp () => 
			@$('.project-name').remove()

	displayRegister: ->
		@register = true
		@mailcheck()
		@$('#login-email').attr('name', 'user[email]').after('<i class="hint icon-ok" />')
		@$('form').attr('action', '/users')
		@$('#login-action').html("Register").show()
		if @$('.username').length == 0 
			$('<div class="input string required username"><label for="login-username" style="display:none;"><i class="icon-pencil" />&nbsp;username</label><input id="login-username" type="text" name="user[username]" title="username" autocomplete="off" /></div>').hide().insertAfter(@.$('.password'))
			.slideDown () =>
				@addJLabel("#login-username")
		if @$('.project-name').length == 0
			$('<div class="input string required project-name"><label for="project-name" style="display:none;"><i class="icon-heart" />&nbsp;What are you working on?</label><input id="project-name" type="text" name="project[name]" title="What are you working on?" autocomplete="off" value="'+(if Ananta.App.currentProject and Ananta.App.currentProject.get('name') then Ananta.App.currentProject.get("name") else "")+'" /></div>').hide().insertAfter(@.$('.username'))
			.slideDown () =>
				@addJLabel("#project-name")
		@checkUsername()
		@checkProjectName()
		@$('.forgot-password').fadeOut(500)

	addMessage: ->
		@$(".facebook").prepend("<h1 class='font-thin'>#{@message}</h1>")

	clearErrors: ->
		@$('.alert-error').remove()

	hideTooltips: ->
		$("#login_register_modal *").tooltip('hide')

	cleanUp: ->
		@clearErrors()
		@clearLoginSpinner()
		@hideTooltips()

	onClose: ->
		@cleanUp()
		$(@el).modal('hide')

_.extend(Ananta.Views.Users.LoginRegisterModal::, Ananta.Mixins.Errors)