Ananta.Views.Locations ||= {}

class Ananta.Views.Locations.AddressFormView extends Backbone.View
	template: JST['backbone/templates/locations/address_form']

	className: 'address-form'

	events:
		'keyup form'                        		: 'keyup'
		'mouseenter .suggested-locations li'		: 'hoverLocation'
		'mouseleave .suggested-locations li'		: 'unhoverLocation'
		'click .suggested-locations li'     		: 'selectLocation'

	initialize: (options) ->
		_.bindAll(@, 'render', 'keyup')
		options or= {}
		@model or= new Ananta.Models.Location(options.location)
		@geocoder = new google.maps.Geocoder()

		@model.bind('change', @render)

	render: ->
		$(@el).html(@template(@))

	keyup: (e) ->
		if e.keyCode == 40
			if @$(".suggested-locations").is(":visible")
				selected = @$(".suggested-locations ul li.selected")
				if selected.length > 0
					selected.removeClass("selected")
					selected.next().addClass("selected")
				else
					@$(".suggested-locations ul li:first").addClass("selected")
		else if e.keyCode == 38
			if @$(".suggested-locations").is(":visible")
				selected = @$(".suggested-locations ul li.selected")
				if selected.length > 0
					selected.removeClass("selected")
					selected.prev().addClass("selected")
		else if e.keyCode == 13
			$li = @$(".suggested-locations ul li.selected")
			f = e
			f.target = $li
			@selectLocation(f)
		else if e.keyCode == 27
			@$(".suggested-locations").slideUp()
		else
			if @$(".address input").val().length > 1
				@suggestLocations(@$(".address input").val())

	hoverLocation: (e) ->
		$(".suggested-locations li").removeClass("selected")
		$(e.target).addClass("selected")

	unhoverLocation: (e) ->
		$(@).removeClass("selected")

	selectLocation: (e) ->
		if $(e.target).is("li")
			$li = $(e.target)
		else
			$li = $(e.target).parent()

		@model.set({ lat: $li.attr("data-lat"), lng: $li.attr("data-lng"), address: $li.find(".address").text() })
		@$(".suggested-locations").slideUp()

	suggestLocations: ->
		value = @$(".address input").val()
		@$(".suggested-locations ul").empty()
		@geocoder.geocode( { 'address': value }, (result, status) =>
			if status == google.maps.GeocoderStatus.OK
				result.each (location) =>
					@$(".suggested-locations ul").append("<li data-lat='"+location.geometry.location.$a+"' data-lng='"+location.geometry.location.ab+"'><div class='address'><i class='icon-map-marker'></i> "+location.formatted_address+"</div></li>")
				@$(".suggested-locations").slideDown()
		)