class Ananta.Models.Project extends Backbone.Model
	toJSON : () =>
		'project': _.clone(@attributes)

	# validate: (attrs) ->
	#	unless attrs.name? and attrs.name.length > 3 
	#		{ 'errors': { 'name': { '0' : 'is too short, please say a little more' } } }

class Ananta.Collections.ProjectsCollection extends Backbone.Collection
	model: Ananta.Models.Project