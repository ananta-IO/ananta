class CommentsController < InheritedResources::Base
	respond_to :html, :json
	belongs_to [:answer, :comment, :project, :user]
	actions :index, :show, :create, :update, :destroy

	before_filter :authenticate_user!, :except => [:index, :show]
	load_and_authorize_resource

	def create
		@comment = current_user.comments.new params[:comment]

		create!
	end
end
