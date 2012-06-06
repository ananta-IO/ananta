class Ananta.Models.Project extends Backbone.Model
	toJSON : () =>
		'project': _.clone(@attributes)

	# validate: (attrs) ->
	#	unless attrs.name? and attrs.name.length > 3 
	#		attr : 'name'
	#		msg  : 'must be 3 or more characters'

class Ananta.Collections.ProjectsCollection extends Backbone.Collection
	model: Ananta.Models.Project