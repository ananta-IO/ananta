class ProfilesController < InheritedResources::Base
	respond_to :html, :json
	defaults :route_prefix => ''
	actions :show, :edit, :update, :edit_location
	
	before_filter :find_users_profile, :only => [:show]
	before_filter :authenticate_user!, :except => [:index, :show]
	load_and_authorize_resource

	after_filter :track_view, :only => [:show]

	def edit
		populate_tags @profile, :bio, :seeking, :offering
		edit!
	end

	def update
		populate_tags @profile, :bio, :seeking, :offering
		update!
	end

protected

	def find_users_profile
		@profile = User.find(params[:id]).profile
	end

	def track_view
		@profile.views.create({user: current_user, ip: remote_ip})
	end

end
