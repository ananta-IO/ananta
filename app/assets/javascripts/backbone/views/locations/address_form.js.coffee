Ananta.Views.Locations ||= {}

class Ananta.Views.Locations.AddressFormView extends Backbone.View
	template: JST['backbone/templates/locations/address_form']

	className: 'address-form'

	events:
		'keydown form'                      		: 'keydown'
		'mouseenter .suggested-locations li'		: 'hoverLocation'
		'mouseleave .suggested-locations li'		: 'unhoverLocation'
		'click .suggested-locations li'     		: 'selectLocation'
		'submit form'                       		: 'save'

	initialize: (options) ->
		_.bindAll(@, 'render', 'keydown')
		options or= {}
		@model or= new Ananta.Models.Location(options.location)
		@geocoder = new google.maps.Geocoder()

		@model.bind('change', @render)

	render: ->
		$(@el).html(@template(@))

	keydown: (e) ->
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

		@model.set(
			name: 'default'
			lat: $li.attr("data-lat")
			lng: $li.attr("data-lng")
			address: $li.attr("data-address") 
			administrative_area_level_1: $li.attr("data-administrative_area_level_1") 
			administrative_area_level_2: $li.attr("data-administrative_area_level_2") 
			country: $li.attr("data-country") 
			postal_code: $li.attr("data-postal_code") 
			data:
				gateway: 'google'
				gateway_version: 'js 3.0' 
				gateway_response: jQuery.parseJSON( $li.attr("data-data") )
		)

		@$(".suggested-locations").slideUp()

	suggestLocations: ->
		partial_address = @$(".address input").val()
		@$(".suggested-locations ul").empty()
		@geocoder.geocode( { 'address': partial_address }, (result, status) =>
			if status == google.maps.GeocoderStatus.OK
				result.each (location) =>
					administrative_area_level_1 = null
					administrative_area_level_2 = null
					country = null
					postal_code = null
					location.address_components.each (component) =>
						if $.inArray('administrative_area_level_1', component.types) != -1 then administrative_area_level_1 = component.long_name
						if $.inArray('administrative_area_level_2', component.types) != -1 then administrative_area_level_2 = component.long_name
						if $.inArray('country', component.types) != -1 then country = component.long_name
						if $.inArray('postal_code', component.types) != -1 then postal_code = component.long_name

					$li = $("<li 
						data-lat='#{location.geometry.location.$a}' 
						data-lng='#{location.geometry.location.ab}' 
						data-address='#{location.formatted_address}' 
						data-administrative_area_level_1='#{administrative_area_level_1}' 
						data-administrative_area_level_2='#{administrative_area_level_2}' 
						data-country='#{country}' 
						data-postal_code='#{postal_code}' 
						data-data='#{JSON.stringify(location)}'>
						<div class='address'><i class='icon-map-marker'></i> #{location.formatted_address}</div></li>")
					@$(".suggested-locations ul").append($li)
				@$(".suggested-locations").slideDown()
		)

	save: (e) ->
		e.preventDefault()
		e.stopPropagation()
		@model.save(null
			success: (data) =>
				@renderFlashes ['location saved successfully']
			error: (data, jqXHR) =>
				errors = $.parseJSON(jqXHR.responseText)
				@renderErrors errors
		)


_.extend(Ananta.Views.Locations.AddressFormView::, Ananta.Mixins.Flashes)
_.extend(Ananta.Views.Locations.AddressFormView::, Ananta.Mixins.Errors)