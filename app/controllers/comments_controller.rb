class CommentsController < InheritedResources::Base
	respond_to :js, :html, :json
	# belongs_to :answer, :comment, :project, :user
	actions :index, :show, :create, :edit, :update, :destroy

	before_filter :authenticate_user!, :except => [:index, :show]
	before_filter :cuid_to_params, :only => :update # TODO: REFACTOR: this is complicated
	load_and_authorize_resource

	def create
		@comment = current_user.comments.new params[:comment]
		create!
	end

protected

	def cuid_to_params
		params[:comment] = add_cuid(params[:comment], :cast_vote) if params[:comment]
	end

end
