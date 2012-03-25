class VersionsController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource

	def revert
		@version = Version.find(params[:id])
		if @version.reify
			@version.reify.save!
		else
			@version.item.destroy
		end

		link_name = params[:redo] == "true" ? "undo" : "redo"
		action_name = params[:redo] == "true" ? "Redid" : "Undid"
		link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), :method => :post)

		if @version.next.item
			redirect_to :back, :notice => "#{action_name} #{@version.event} of #{@version.next.item.name}. #{link}"
		else
			redirect_to profile_url(current_user), :notice => "#{action_name} #{@version.event} of #{@version.next.reify.name}. #{link}"
		end
	end
end