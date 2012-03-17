class ProjectsController < InheritedResources::Base
	respond_to :js, :html, :json
	belongs_to :user
	defaults :route_prefix => ''
	before_filter :populate_tags, :only => [:new, :create, :edit, :update]
	before_filter :populate_selected_tags, :only => [:edit, :update]

	before_filter :authenticate_user!, :except => [:index, :show]
	before_filter :cuid_to_params, :only => :update
	load_and_authorize_resource

	protected

	def collection
		@projects ||= end_of_association_chain.page(params[:page]).per(10)
	end

	def cuid_to_params
		params[:project] = add_cuid(params[:project], :cast_vote) if params[:project]
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