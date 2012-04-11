# # Remove flash after a few seconds
# $(window).load () ->
#	$('#flash .alert').show('fade', {}, 1000).delay(8000).slideUp(500)

# Stop dropdowns from closing when input field clicked
$('.dropdown input').bind 'click', (e) ->
	e.stopPropagation()

# Open login and register modal
$('a.login').bind 'click', (e) ->
	callback = ->
		window.location = '/'
	modalView = new Ananta.Views.Users.LoginRegisterModal({ callback: callback })
	modalView.render()
	e.stopPropagation()