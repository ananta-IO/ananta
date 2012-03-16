class AnswersController < InheritedResources::Base
	respond_to :html, :json
	belongs_to :question
	actions :index, :show, :create, :update

	before_filter :authenticate_user!, :except => [:index, :show]
	load_and_authorize_resource

	def show
		super do |format|
			format.html { redirect_to @question }
		end
	end

	def create
		@question = Question.find(params[:question_id])

		attrs = {}

		attrs[:state_event] = params[:state_event]
		attrs[:user_id] = current_user ? current_user.id : nil
		unless pick(params, :comment)[:comment].blank?
			attrs[:comment_attributes] = {}
			attrs[:comment_attributes][:comment] = params[:comment]
			attrs[:comment_attributes][:user_id] = attrs[:user_id]	
		end

		@answer = @question.answers.new attrs

		create!
	end
end
