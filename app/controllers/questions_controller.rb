class QuestionsController < InheritedResources::Base
	#########################
	# Response Types
	#########################
	respond_to :html, :json
	actions :index, :create, :update


	#########################
	# Scopes
	#########################
	has_scope :published, :type => :boolean, :only => :index, :default => true
	has_scope :answered, :type => :boolean, :only => :index
	# has_scope :answered_by # This is not exposed at the moment #TODO: should it be exposed?
	has_scope :unanswered, :type => :boolean, :only => :index
	has_scope :unanswered_by, :only => :index do |controller, scope, value|
		value != "me" ? scope.unanswered_by(value) : (controller.current_user ? scope.unanswered_by(controller.current_user.id) : scope)
	end
	has_scope :q_url, :only => :index do |controller, scope, value|
		value != "current" ? scope.q_url(value) : scope.q_url(controller.session[:questionable_url])
	end
	has_scope :q_sid, :only => :index do |controller, scope, value|
		value != "current" ? scope.q_sid(value) : scope.q_sid(controller.session[:questionable_sid])
	end
	has_scope :q_controller, :only => :index do |controller, scope, value|
		value != "current" ? scope.q_controller(value) : scope.q_controller(controller.session[:questionable_controller])
	end
	has_scope :q_action, :only => :index do |controller, scope, value|
		value != "current" ? scope.q_action(value) : scope.q_action(controller.session[:questionable_action])
	end
	has_scope :order, :only => :index do |controller, scope, value|
		scope.order(value)
	end
	has_scope :page, :only => :index, :default => 1 do |controller, scope, value|
		value.to_i > 0 ? scope.page(value.to_i) : scope.page(1)
	end
	has_scope :per, :only => :index, :default => 10 do |controller, scope, value|
		(1..100) === value.to_i ? scope.per(value.to_i) : scope.per(10)
	end
	has_scope :select, :only => :index 
	has_scope :uniq, :type => :boolean


	#########################
	# Authentication
	#########################
	before_filter :authenticate_user!, :except => [:index, :show]
	# load_and_authorize_resource # TODO: uncomment and fix bug with query :per


	#########################
	# Modifited Actions
	#########################
	def create
		attrs = {}
		attrs = attrs.merge pick(params, :question, :questionable_url)
		attrs[:questionable_sid]		= session[:questionable_sid]
		attrs[:questionable_controller] = session[:questionable_controller]
		attrs[:questionable_url]   		||= session[:questionable_url]
		attrs[:questionable_action]		= session[:questionable_action]

		@question = current_user.questions.new attrs

		create!
	end


	#########################
	# Protected Methods
	#########################
	protected

	def collection
		@questions ||= apply_scopes(end_of_association_chain)
	end
end
