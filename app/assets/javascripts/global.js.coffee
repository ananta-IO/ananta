jQuery ->
	window.initUI()

window.initUI = ->
	window.initFlashes()
	window.initInfiniteScroll()
	window.initBootstrap()
	window.styleAmp()

# Remove flash after a few seconds
# But only if the flash does not contain a link
window.initFlashes = ->
	flash = $('#flash .alert')
	flash.show('fade', {}, 1000)
	unless flash.has('a').length > 0
		flash.delay(8000).slideUp 500, () =>
			flash.remove()

window.initInfiniteScroll = ->
	if $('.pagination').length > 0
		$(window).scroll ->
			url = $('.pagination .next a').attr('href')
			if url? and $('body').scrollTop() > $('#wrapper').height() - $('body').height() - 120
				$('.pagination').html('<li class="active"><a href="#">Loading more...</a></li>')
				$.getScript(url)
		$(window).scroll()

window.initBootstrap = ->
	# $('.modal').modal();
	# $('.dropdown-toggle').dropdown();
	# $('.scrollspy').scrollSpy();
	# $('.btn').button();
	# $('.tabs').tabs();
	$("[rel*=tooltip]").tooltip();
	$("[rel*=popover]").popover();
	# $('.alert').alert();
	# $('.collapse').collapse();
	# $('.carousel').carousel();
	# $('.typeahead').typeahead();

	# $('body').jScrollPane({autoReinitialise: true});

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
	window.loginModal = new Ananta.Views.Users.LoginRegisterModal()
	window.loginModal.render()
	Analytical.event('Manually Open Login Modal', { location: window.location.href } )
	e.stopPropagation()
