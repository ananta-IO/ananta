class Ananta.Models.Location extends Backbone.Model
	urlRoot: '/locations'
	
	defaults:
		name: null
		# address: null
		# street: null
		# city: null
		# state: null
		# zipcode: null
		# lat: null
		# lng: null
		# timezone: null
	
class Ananta.Collections.LocationsCollection extends Backbone.Collection
	model: Ananta.Models.Location
	url: '/locations'