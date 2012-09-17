class CommentsController < InheritedResources::Base
	respond_to :js, :html, :json
	belongs_to :answer, :comment, :project, :user, :polymorphic => true, :optional => true
	actions :index, :show, :create, :edit, :update, :destroy

	before_filter :authenticate_user!, :except => [:index, :show]
	before_filter :cuid_to_params, :only => :update # TODO: REFACTOR: this is complicated
	load_and_authorize_resource

	def create
		@comment = current_user.comments.new params[:comment]
		create!
	end

protected

	def collection
		@comments = end_of_association_chain.reorder(sort_column + " " + sort_direction)
	end

	def cuid_to_params
		params[:comment] = add_cuid(params[:comment], :cast_vote) if params[:comment]
	end

private

	def sort_column
		session["comment_sort_attribute"] = params[:sort] if params[:sort]
		Comment.column_names.include?(session["comment_sort_attribute"]) ? session["comment_sort_attribute"] : "created_at"
	end

	def sort_direction
		session["comment_sort_direction"] = params[:direction] if params[:direction]
		%w[asc desc].include?(session["comment_sort_direction"]) ? session["comment_sort_direction"] : "asc"
	end

end
