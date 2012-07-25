class ProfilesController < InheritedResources::Base
	respond_to :html, :json
	defaults :route_prefix => ''
	actions :show, :edit, :update, :edit_location
	
	before_filter :authenticate_user!, :except => [:index, :show]
	load_and_authorize_resource

	def show
		@profile.views.create({user: current_user, ip: remote_ip})
		show!
	end

	def edit
		populate_tags @profile, :bio, :seeking, :offering
		edit!
	end

	def update
		populate_tags @profile, :bio, :seeking, :offering
		update!
	end
end
