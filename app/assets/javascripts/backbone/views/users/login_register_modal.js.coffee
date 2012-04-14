Ananta.Views.Users ||= {}

class Ananta.Views.Users.LoginRegisterModal extends Backbone.View    
	template: JST["backbone/templates/users/login_register_modal"]

	className: 'modal fade'
	id: 'login_register_modal'

	events:
		'click .fb-login-button'		: 'facebookLogin'
		'click .show-email a'   		: 'expand'
		'focus #login-password' 		: 'passwordFocus'
		'blur #login-password'  		: 'passwordBlur'
		'blur #login-email'     		: 'checkEmail'
		'keyup #login-password' 		: 'checkPassword'
		'keyup #username'       		: 'checkUsername'

	initialize: (options) ->
		_.bindAll(@, 'render')
		@user = new Ananta.Models.User( options.user )
		@callback = options.callback
		@register = false
		@checkUser()

	checkUser: () ->
		if @user.get('id') == null
			@register = true

	render: () ->
		$(@el).html(@template( @user.toJSON() ))
		$(@el).modal('show')
		@addCSRF()
		if !@register
			@$('#login-email').attr('name', 'user[login]')
			@$('form').attr('action', '/users/sign_in')
			@$('.separator').hide()
			@$('.email').hide()
			@$('.username').remove()
			$('<p class="show-email"><a href="#">Don\'t have a Facebook account?</a></p>').insertAfter(@$('.facebook'))
		else
			@checkEmail()
			@checkUsername()
			@addJLabel(".string input")
			@$('.forgot-password').hide()
			@$('.separator span').hide()
			wait 1000, =>
				@$('#login-password').focus()
				@$('.facebook img').tooltip({ placement:'bottom', title:'finish registration <i class="icon-arrow-down"/>' }).tooltip('show')
				wait 4000, =>
					@$('.facebook img').tooltip('hide')

	expand: (e) ->
		@$('#login-action').hide()
		@$('.show-email').hide()
		@$('.separator').slideDown()
		@$('.email').slideDown()
		@addJLabel(".string input")
		e.preventDefault()
		e.stopPropagation()

	passwordFocus: () ->
		@$('.forgot-password').fadeOut(500)

	passwordBlur: () ->
		if @$('#login-password').val() == '' and @register == false
			@$('.forgot-password').fadeIn(500)

	checkEmail: () ->
		if @$('#login-email').val() != @email and @$('#login-email').val() != ''
			@email = @$('#login-email').val()
			@$('.login-email i').tooltip('hide').remove()
			@$('#login-email').attr('disabled', 'disabled').after('<img src="/assets/ajax-loader-black-dots.gif" class="loader" />')
			email_pattern = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
			space_pattern = /\s/;
			if(email_pattern.test(@email) && space_pattern.test(@email) == false)
				$.ajax
					dataType : 'json'
					type : 'GET'
					url : '/users'
					data :
						email : @email
					success: (data) =>
						@$('.email .loader').remove()
						@$('#login-email').removeAttr('disabled')
						if data.length > 0
							@register = false
							@$('#login-email').attr('name', 'user[login]').after('<i class="icon-ok" />')
							@$('form').attr('action', '/users/sign_in')
							@$('#login-action').html("Login").show()
							if !@$('#login-password').is(':focus') then @$('.forgot-password').fadeIn(500)
							@$('.username').slideUp()
							wait 600, =>
								@$('.username').remove()
						else
							@register = true
							@$('#login-email').attr('name', 'user[email]').after('<i class="icon-ok" />')
							@$('form').attr('action', '/users')
							@$('#login-action').html("Register").show()
							if @$('.username').length == 0
								$('<div class="input string required username"><input id="username" type="text" name="user[username]" title="username" autocomplete="off" /></div>').hide().insertAfter(@.$('.password')).slideDown()
								@addJLabel("#username")
							@$('.forgot-password').fadeOut(500)
           
			else
				@$('.email .loader').remove()
				@$('#login-email').removeAttr('disabled')
				.after('<i class="icon-remove" />')
				@$('.login-email i').tooltip({placement: 'top', title: "that's not an email"}).tooltip('show')

	checkPassword: () ->
		@password = @$('#login-password').val()
		@$('.password i').tooltip('hide').remove()
		if @password != ''
			@$('#login-password').after('<img src="/assets/ajax-loader-black-dots.gif" class="loader" />')
			if @password.length < 8
				@$('.password .loader').remove()
				@$('#login-password').after('<i class="icon-remove" />')
				@$('.password i').tooltip({placement: 'top', title: "must be 8 or more characters"}).tooltip('show')
			else
				@$('.password .loader').remove()
				@$('#login-password').after('<i class="icon-ok" />')

	checkUsername: () ->
		@username = @$('#username').val()
		@$('.username i').tooltip('hide').remove()
		username_pattern = /^[A-Za-z-]*$/i
		if @username != ''
			@$('#username').after('<img src="/assets/ajax-loader-black-dots.gif" class="loader" />')
			if @username.length < 3
				@$('.username .loader').remove()
				@$('#username').after('<i class="icon-remove" />')
				@$('.username i').tooltip({placement: 'top', title: "must be 3 or more letters"}).tooltip('show')
			else if !username_pattern.test(@username)
				@$('.username .loader').remove()
				@$('#username').after('<i class="icon-remove" />')
				@$('.username i').tooltip({placement: 'top', title: "letters and hyphens only"}).tooltip('show')
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
							@$('#username').after('<i class="icon-ok" />')		
						else
							@$('#username').after('<i class="icon-remove" />')
							@$('.username i').tooltip({placement: 'top', title: "taken"}).tooltip('show')
						

	facebookLogin: (e) ->
		@$('.fb-login-button img').addClass('rideSpinners')
		fbLogin()
		e.preventDefault()
		e.stopPropagation()

	addJLabel: (element) ->
		wait 500, =>
			$(@el).find(element).jLabel({color: "#999", yShift: '-2'})
			$(@el).find(element).click ->
				$(@).parent().find('input').focus()

	addCSRF: () ->
		authenticity_token = $("<div style='margin:0;padding:0;display:inline'><input name='utf8' type='hidden' value='✓'><input name='authenticity_token' type='hidden' value='#{$('meta[name="csrf-token"]').attr('content')}'></div>")
		@$('form').prepend(authenticity_token)
