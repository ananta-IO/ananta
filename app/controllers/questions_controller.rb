class QuestionsController < InheritedResources::Base
	#########################
	# Config via inherited_resources https://github.com/josevalim/inherited_resources 
	#########################
	respond_to :js, :html, :json
	actions :index, :show, :create, :update


	#########################
	# Scopes via has_scope https://github.com/plataformatec/has_scope
	#########################
	has_scope :published, :type => :boolean, :only => :index, :default => true
	has_scope :answered, :type => :boolean, :only => :index
	has_scope :answered_by, :only => :index, :default => 'me' do |controller, scope, value|
		if value == 'ireadthecode'
			# Way to go! No scope for you!
			scope
		else
			# Just hide the answers in the view
			scope
			# controller.current_user ? scope.answered_by(controller.current_user.id) : scope.answered_by(0)
		end
	end
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
	has_scope :per, :only => :index, :default => Proc.new { |c| c.session[:questions_per] ? c.session[:questions_per] : 10 } do |controller, scope, value|
		if controller.request.format != 'html' # API request
			scope.per(value.to_i) if (1..100) === value.to_i
		else
			controller.session[:questions_per] = value.to_i if (1..100) === value.to_i
			controller.session[:questions_per] ? scope.per(controller.session[:questions_per]) : scope.per(10)
		end
	end
	has_scope :select, :only => :index 
	has_scope :uniq, :type => :boolean


	#########################
	# Callbacks. Auth & Permissions via devise & cancan.
	#########################
	before_filter :authenticate_user!, :except => [:index, :show]
	before_filter :cuid_to_params, :only => :update
	load_and_authorize_resource

	after_filter :track_view, :only => [:show]


	#########################
	# Modifited Actions
	#########################

	def create
		attrs = {}
		attrs = attrs.merge pick(params[:question], :question, :questionable_url)
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

	def cuid_to_params
		params[:question] = add_cuid(params[:question], :cast_vote) if params[:question]
	end

	def track_view
		@question.views.create({user: current_user, ip: remote_ip})
	end
end
