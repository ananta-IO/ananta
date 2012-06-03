# Remove flash after a few seconds
# But only if the flash does not contain a link
$(window).load () ->
	window.initFlashes()

window.initFlashes = () ->
	flash = $('#flash .alert')
	flash.show('fade', {}, 1000)
	unless flash.has('a').length > 0
		flash.delay(8000).slideUp 500, () =>
			flash.remove()

# Stop dropdowns from closing when input field clicked
$('.dropdown input').bind 'click', (e) ->
	e.stopPropagation()

# Open login and register modal
$('a.login').bind 'click', (e) ->
	window.loginModal = new Ananta.Views.Users.LoginRegisterModal()
	window.loginModal.render()
	e.stopPropagation()