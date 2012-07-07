Ananta.Views.Locations ||= {}

class Ananta.Views.Locations.AddressFormView extends Backbone.View
	template: JST['backbone/templates/locations/address_form']

	className: 'address-form'

	events:
		'keyup input.address'              : 'suggestLocations'

	initialize: (options) ->
		_.bindAll(@, 'render')
		options or= {}
		@model or= new Ananta.Models.Location(options.location)
		@geocoder = new google.maps.Geocoder()

	render: ->
		$(@el).html(@template( @model.toJSON() ))

	suggestLocations: (value) ->
		@$(".suggested-locations ul").empty()
		@geocoder.geocode( { 'address': value }, (result, status) =>
			if status == google.maps.GeocoderStatus.OK
				result.each (location) =>
					@$(".suggested-locations ul").append("<li data-lat='"+location.geometry.location.$a+"' data-lng='"+location.geometry.location.ab+"'><div class='address'>"+location.formatted_address+"</div></li>")
				@$(".suggested-locations").slideDown()
		)