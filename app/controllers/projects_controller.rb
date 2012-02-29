class ProjectsController < InheritedResources::Base
	respond_to :js, :html, :json
	belongs_to :user
	defaults :route_prefix => ''

	before_filter :authenticate_user!
	before_filter :current_user_to_params, :only => :update
	load_and_authorize_resource

	protected

	def current_user_to_params
		params[:project] ||= {}
		params[:project][:current_user_id] = current_user.id 
	end
end