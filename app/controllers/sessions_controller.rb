class SessionsController < InheritedResources::Base
	#########################
	# Config via inherited_resources https://github.com/josevalim/inherited_resources 
	#########################
	respond_to :json
	actions :index


	#########################
	# Scopes via has_scope https://github.com/plataformatec/has_scope
	#########################


	#########################
	# Callbacks. Auth & Permissions via devise & cancan.
	#########################
	# before_filter :authenticate_user!, :except => [:index, :show]
	# load_and_authorize_resource


	#########################
	# Modifited Actions
	#########################


	#########################
	# Protected Methods
	#########################
	protected

	def collection
		attrs = {}
		attrs[:questionable_sid]		= session[:questionable_sid]
		attrs[:questionable_controller] = session[:questionable_controller]
		attrs[:questionable_url]   		= session[:questionable_url]
		attrs[:questionable_action]		= session[:questionable_action]
		@sessions ||= attrs
	end
end