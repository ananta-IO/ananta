class ProjectsController < InheritedResources::Base
	#########################
	# Config via inherited_resources https://github.com/josevalim/inherited_resources 
	#########################
	respond_to :js, :html, :json
	belongs_to :user, :optional => true
	

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
	before_filter :authenticate_user!, :except => [:index, :show, :random]
	before_filter :cuid_to_params, :only => :update # TODO: REFACTOR: this is complicated
	load_and_authorize_resource

	after_filter :track_view, :only => [:show]


	#########################
	# Modifited Actions
	#########################

	def new
		populate_tags @project, :tags
		new!
	end

	def create
		populate_tags @project, :tags
		@project.location ||= @user.location.dup rescue nil
		create! do |success, failure|
			success.html do 
				# flash[:notice] = "Successfully created project. #{undo_link}" # TODO: enable undo/redo eventually
				redirect_to user_project_url(@user, @project)
			end
			success.json do
				flash[:notice] = "Project created."
			end
		end
	end

	def edit
		populate_tags @project, :tags
		edit!
	end

	def update
		populate_tags @project, :tags
		params[:project] ||= {}
		params[:project] = pick(params[:project], :name, :description, :state_event, :tag_tokens, :cast_vote)
		update! do |success, failure|
			success.html do 
				# flash[:notice] = "Successfully updated project. #{undo_link}"
				redirect_to user_project_url(@user, @project)
			end
			success.json do
				flash[:notice] = "Project update."
			end
		end
	end

	def destroy
		populate_tags @project, :tags
		destroy! do |success, failure|
			success.html do 
				# flash[:notice] = "Successfully deleted project. #{undo_link}"
				redirect_to profile_url(@user)
			end
		end
	end

	def random
		@project = Project.order("RANDOM()").first
		redirect_to([@project.user, @project])
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

	# def undo_link
	#	view_context.link_to("undo", revert_version_path(@project.versions.scoped.last), :method => :post)
	# end

	def track_view
		@project.views.create({user: current_user, ip: remote_ip})
	end

end