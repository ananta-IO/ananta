object @project

attributes :id, :created_at, :description, :lat, :lng, :name, :slug, :state, :timezone, :updated_at, :user_id

node :url do |project|
	user_projects_url([project.user, project])
end