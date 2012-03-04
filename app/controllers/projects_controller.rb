class ProjectsController < InheritedResources::Base
	respond_to :js, :html, :json
	belongs_to :user
	defaults :route_prefix => ''
	before_filter :populate_tags, :only => [:new, :create, :edit, :update]
	before_filter :populate_selected_tags, :only => [:edit, :update]

	before_filter :authenticate_user!
	before_filter :current_user_to_params, :only => :update
	load_and_authorize_resource

	protected

	def current_user_to_params
		params[:project] ||= {}
		params[:project][:current_user_id] = current_user.id 
	end

	def populate_tags
    @tags = {}
    @tags['tags'] = Project.tag_counts_on(:tags).where("name like ?", "%#{params[:q]}%").map{|t| {:id => t.name, :name => t.name}}

    @selected_tags = {}
  end

  def populate_selected_tags
		@project = Project.find(params[:id])

    @selected_tags['tags'] = @project.tags.map{|t| {:id => t.name, :name => t.name}}
	end
end