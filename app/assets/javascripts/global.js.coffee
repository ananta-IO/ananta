# Remove flash after a few seconds
# But only if the flash does not contain a link
jQuery ->
	window.initUI()

window.initUI = ->
	window.initFlashes()
	window.initInfiniteScroll()
	window.styleAmp()

window.initFlashes = ->
	flash = $('#flash .alert')
	flash.show('fade', {}, 1000)
	unless flash.has('a').length > 0
		flash.delay(8000).slideUp 500, () =>
			flash.remove()

window.initInfiniteScroll = ->
	if $('.pagination').length
		$('#pg-scrl').scroll ->
			url = $('.pagination .next a').attr('href')
			if url? and $('#pg-scrl').scrollTop() > $('#wrapper').height() - $('#pg-scrl').height() - 120
				$('.pagination').html('<li class="active"><a href="#">Loading more...</a></li>')
				$.getScript(url)
		$('#pg-scrl').scroll()

window.styleAmp = ->
	foundin = $('*:contains("&")')
	foundin.each () ->
		if $(@).children().length < 1 and $(@).attr('class') and !$(@).attr('class').match(/amp/)
			$(@).html(
				$(@).text().replace(
					/&/
					"<span class='amp'>&</span>"
				)
			)

# Stop dropdowns from closing when input field clicked
$('.dropdown input').bind 'click', (e) ->
	e.stopPropagation()

# Open login and register modal
$('a.login').bind 'click', (e) ->
	Analytical.event('Manually Open Login Modal', { with: { location: window.location.href } } )
	window.loginModal = new Ananta.Views.Users.LoginRegisterModal()
	window.loginModal.render()
	e.stopPropagation()
