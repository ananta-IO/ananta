class QuestionsController < InheritedResources::Base
	#########################
	# Response Types
	#########################
	respond_to :html, :json
	actions :index, :create, :update


	#########################
	# Scopes
	#########################
	has_scope :unanswered, :type => :boolean, :only => :index
	has_scope :unanswered_by, :only => :index do |controller, scope, value|
		value != "me" ? scope.unanswered_by(value) : (controller.current_user ? scope.unanswered_by(controller.current_user.id) : scope)
	end
	has_scope :order, :only => :index, :default => 'score DESC' do |controller, scope, value|
		scope.order(value)
	end
	has_scope :page, :only => :index, :default => 1 do |controller, scope, value|
		value.to_i > 0 ? scope.page(value.to_i) : scope.page(1)
	end
	has_scope :per, :only => :index, :default => 10 do |controller, scope, value|
		(1..100) === value.to_i ? scope.per(value.to_i) : scope.per(10)
	end


	#########################
	# Authentication
	#########################
	before_filter :authenticate_user!, :except => [:index, :show]
	# load_and_authorize_resource # TODO: uncomment and fix bug with query :per


	#########################
	# Modifited Actions
	#########################
	def create
		@question = current_user.questions.new pick(params, :question, :questionable_url)
		create!
	end


	#########################
	# Protected Methods
	#########################
	protected

	def collection
		@questions ||= apply_scopes(end_of_association_chain).all
	end
end
