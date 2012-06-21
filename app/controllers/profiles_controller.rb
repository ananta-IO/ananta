class ProfilesController < InheritedResources::Base
	respond_to :html, :json
	defaults :route_prefix => ''
	actions :show, :edit, :update
	
	before_filter :authenticate_user!, :except => [:index, :show]
	load_and_authorize_resource

	def edit
		populate_tags @profile, :bio_tags, :skills, :needs
		edit!
	end

	def update
		populate_tags @profile, :bio_tags, :skills, :needs
		update!
	end
end
