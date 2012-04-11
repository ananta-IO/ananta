Ananta.Views.Users ||= {}

class Ananta.Views.Users.LoginRegisterModal extends Backbone.View    
	template: JST["backbone/templates/users/login_register_modal"]

	className: 'modal fade'
	id: 'login_register_modal'

	events:
		'click .show-email a'  		: 'expand'
		'focus #login-password'		: 'passwordFocus'
		'blur #login-password' 		: 'passwordBlur'
		'blur #login-email'    		: 'checkEmail'

	initialize: (options) ->
		_.bindAll(@, 'render')
		@user = options.user
		@callback = options.callback
		@register = false

	render: () ->
		$(@el).html(@template())
		$(@el).modal('show')
		@.$('.separator').hide()
		@.$('.email').hide()
		$('<p class="show-email"><a href="#">Don\'t have a Facebook account?</a></p>').insertAfter(@.$('.facebook'))

	expand: () ->
		@.$('.show-email').hide()
		@.$('.separator').slideDown()
		@.$('.email').slideDown()
		$(this.el).find(".string input").jLabel({color: "#999", yShift: '-2'})
		$(this.el).find(".string label").click ->
			$(this).parent().find('input').focus()
		return false

	passwordFocus: () ->
		@.$('.forgot-password').fadeOut(500)

	passwordBlur: () ->
		if @.$('#login-password').val() == '' and @register == false
			@.$('.forgot-password').fadeIn(500)

	checkEmail: () ->
		if @.$('#login-email').val() != @email and @.$('#login-email').val() != ''
			@email = @.$('#login-email').val()
			@.$('#login-email').attr('disabled', 'disabled').after('<img src="/assets/ajax-loader-black-dots.gif" class="loader" />')
			$.ajax
				dataType : 'json'
				type : 'GET'
				url : '/users'
				data :
					email : @email
				success: (data) =>
					@.$('.email .loader').remove()
					@.$('#login-email').removeAttr('disabled')
					if data.length > 0
						@.$('#login-email').after('<i class="icon-ok" />')
					else
						@.$('.login-email .icon-ok').remove()
