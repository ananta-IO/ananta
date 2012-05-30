class ProjectsController < InheritedResources::Base
	#########################
	# Config via inherited_resources https://github.com/josevalim/inherited_resources 
	#########################
	respond_to :js, :html, :json
	belongs_to :user, :optional => true
	defaults :route_prefix => ''


	#########################
	# Scopes via has_scope https://github.com/plataformatec/has_scope
	#########################
	has_scope :order, :only => :index do |controller, scope, value|
		case value
		when 'r'
			scope.order("RANDOM()")
		else
			scope.order(value)
		end
	end
	has_scope :page, :only => :index, :default => 1 do |controller, scope, value|
		value.to_i > 0 ? scope.page(value.to_i) : scope.page(1)
	end
	has_scope :per, :only => :index, :default => Proc.new { |c| c.session[:projects_per] ? c.session[:projects_per] : 10 } do |controller, scope, value|
		if controller.request.format != 'html' # API request
			scope.per(value.to_i) if (1..100) === value.to_i
		else
			controller.session[:projects_per] = value.to_i if (1..100) === value.to_i
			controller.session[:projects_per] ? scope.per(controller.session[:projects_per]) : scope.per(10)
		end
	end


	#########################
	# Callbacks. Auth & Permissions via devise & cancan.
	#########################
	before_filter :populate_tags, :only => [:new, :create, :edit, :update, :destroy]
	before_filter :populate_selected_tags, :only => [:edit, :update]

	before_filter :authenticate_user!, :except => [:index, :show]
	before_filter :cuid_to_params, :only => :update
	load_and_authorize_resource


	#########################
	# Modifited Actions
	#########################
	def create
		@project.location = @user.location.dup
		create! do |success, failure|
			success.html do 
				flash[:notice] = "Successfully created project. #{undo_link}"
				redirect_to user_project_url(@user, @project)
			end
		end
	end

	def update
		update! do |success, failure|
			success.html do 
				flash[:notice] = "Successfully updated project. #{undo_link}"
				redirect_to user_project_url(@user, @project)
			end
		end
	end

	def destroy
		destroy! do |success, failure|
			success.html do 
				flash[:notice] = "Successfully deleted project. #{undo_link}"
				redirect_to profile_url(@user)
			end
		end
	end


	#########################
	# Protected Methods
	#########################
	protected

	def collection
		@projects ||= apply_scopes(end_of_association_chain)
	end

	def cuid_to_params
		params[:project] = add_cuid(params[:project], :cast_vote) if params[:project]
	end

	def populate_tags
		@tags = {}
		@tags['tags'] = Project.tag_counts_on(:tags).where("name like ?", "%#{params[:q]}%").map{|t| {:id => t.name, :name => t.name}}

		@selected_tags = {}
	end

	def populate_selected_tags
		@project = Project.find(params[:id])

		@selected_tags['tags'] = @project.tags.map{|t| {:id => t.name, :name => t.name}}
	end

	def undo_link
		view_context.link_to("undo", revert_version_path(@project.versions.scoped.last), :method => :post)
	end
end