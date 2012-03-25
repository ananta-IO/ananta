class VersionsController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource

	def revert
		@version = Version.find(params[:id])
		@version.reify.save!
		
		link_name = params[:redo] == "true" ? "undo" : "redo"
		link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), :method => :post)
		redirect_to :back, :notice => "Undid #{@version.event}. #{link}"
	end
end