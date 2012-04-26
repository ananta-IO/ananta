class TemplateController < InheritedResources::Base
	#########################
	# Config via inherited_resources https://github.com/josevalim/inherited_resources 
	#########################
	respond_to :html, :json
	actions :index, :create, :update


	#########################
	# Scopes via has_scope https://github.com/plataformatec/has_scope
	#########################
	has_scope :order, :only => :index, :default => 'created_at DESC' do |controller, scope, value|
		scope.order(value)
	end
	has_scope :page, :only => :index, :default => 1 do |controller, scope, value|
		value.to_i > 0 ? scope.page(value) : scope.page(1)
	end
	has_scope :per, :only => :index, :default => 10 do |controller, scope, value|
		(1..100) === value.to_i ? scope.per(value.to_i) : scope.per(10)
	end


	#########################
	# Callbacks. Auth & Permissions via devise & cancan.
	#########################
	before_filter :authenticate_user!, :except => [:index, :show]
	load_and_authorize_resource


	#########################
	# Modifited Actions
	#########################

	# def create
	#	@template = current_user.templates.new pick(params, :attr1, :attr2)
	#	create!
	# end


	#########################
	# Protected Methods
	#########################
	protected

	def collection
		@templates ||= apply_scopes(end_of_association_chain)
	end
end
