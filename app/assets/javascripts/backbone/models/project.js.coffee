class Ananta.Models.Project extends Backbone.Model
	toJSON : () =>
		'project': _.clone(@attributes)

class Ananta.Collections.ProjectsCollection extends Backbone.Collection
	model: Ananta.Models.Project