class AnswersController < InheritedResources::Base
	respond_to :html, :json
	belongs_to :question
	actions :index, :show, :create, :update

	before_filter :authenticate_user!, :except => [:index, :show]
	load_and_authorize_resource :only => [:index, :show, :update] # TODO: load and authorize "create" without breaking comment mass assignment

	def show
		super do |format|
			format.html { redirect_to @question }
		end
	end

	def create
		@question = Question.find(params[:question_id])

		@answer = @question.answer params[:answer], current_user

		create!
	end
end
