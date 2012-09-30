class ProjectMembershipsController < InheritedResources::Base
	respond_to :html, :json
	actions :none

	before_filter :authenticate_user!
	load_and_authorize_resource

	def accept
		@project_membership.accept
		flash[:notice] = 'Membership accepted.'
		redirect_to user_project_path(@project_membership.project.user, @project_membership.project)
	end

	def reject
		@project_membership.reject
		flash[:notice] = 'Membership rejected.'
		redirect_to user_project_path(@project_membership.project.user, @project_membership.project)
	end
end