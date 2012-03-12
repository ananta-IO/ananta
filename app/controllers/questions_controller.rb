class QuestionsController < InheritedResources::Base
	respond_to :html, :json
	actions :index, :create, :update

	# has_scope :unanswered, :type => :boolean, :only => :index
	# has_scope :unanswered_by, :only => :index do |controller, scope, value|
	#	value != "me" ? scope.unanswered_by(value) : (controller.current_user ? scope.unanswered_by(controller.current_user.id) : scope)
	# end

	before_filter :authenticate_user!, :except => [:index, :show]
	# load_and_authorize_resource # TODO: uncomment and fix bug with query :per

	def create
		@question = current_user.questions.new pick(params, :question, :questionable_url)
		create!
	end

	protected

	def collection
		# @questions ||= apply_scopes(end_of_association_chain).all
		@questions ||= end_of_association_chain.published.order('score DESC')
		@questions = @questions.unanswered if params[:unanswered] == 'true'
		@questions = @questions.unanswered_by(params[:unanswered_by] == 'me' ? current_user.id : params[:unanswered_by].to_i) rescue @questions if params[:unanswered_by] 
		@questions = Kaminari.paginate_array(@questions).page( params[:page] || 1 ).
		per( ((1..100) === params[:per].to_i ? params[:per].to_i : 10) )
	end
end
