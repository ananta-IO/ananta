class QuestionsController < InheritedResources::Base
	respond_to :html, :json
	actions :index, :create, :update

	before_filter :authenticate_user!, :except => [:index, :show]
	# load_and_authorize_resource # TODO: uncomment and fix bug with query :per

	def create
		@question = current_user.questions.new pick(params, :question, :questionable_url)
		create!
	end

	protected

	def collection
		@questions ||= end_of_association_chain.published.
		page( params[:page] ).
		per( ((1..100) === params[:per].to_i ? params[:per] : 10) )
	end
end
