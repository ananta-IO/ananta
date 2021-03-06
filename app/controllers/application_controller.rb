class ApplicationController < ActionController::Base
	# TODO: LAUNCH - remove this
	http_basic_authenticate_with :name => "infinite", :password => "panda" if %w(production sandbox).include?(Rails.env)
	
	protect_from_forgery

	analytical use_session_store: true, modules: [:console]                   	if %w(development sandbox test).include?(Rails.env)
	analytical use_session_store: true, modules: [:console, :mixpanel]        	if Rails.env == 'staging'
	analytical use_session_store: true, modules: [:mixpanel, :google, :clicky]	if Rails.env == 'production'

	before_filter :miniprofiler
	before_filter :set_markdown
	after_filter  :set_questionable, :if =>  lambda { request.format == 'html' }

	# Default cancan redirect url
	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_url, :alert => exception.message
	end

	# Initialize cancan
	def current_ability
		@current_ability ||= Ability.new(current_user, params)
	end

	# Devise after sign in hack     # TODO: make less hacky, maybe update the /users route?
	# def after_sign_in_path_for(resource)
	#	request.referer =~ /\/users/ ? root_url : super
	# end

	# Helper method for picking allowed keys from a hash of params
	# http://www.quora.com/Backbone-js-1/How-well-does-backbone-js-work-with-rails
	def pick(hash, *keys)
		filtered = {}
		hash.each do |key, value| 
			filtered[key.to_sym] = value if keys.include?(key.to_sym) 
		end
		filtered
	end

	# Helper to insert the Current User ID (cuid) into hash fields that need it
	# Adds nil if no current_user
	def add_cuid(hash, *keys)
		keys.each do |key|
			hash[key][:cuid] = (current_user.id rescue nil) if hash[key]
		end
		hash
	end

	def set_markdown
		unless $markdown
			rndr = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
			$markdown = Redcarpet::Markdown.new(rndr, autolink: true, space_after_headers: false, strikethrough: true, superscript: true)
		end
	end

	# Store some params about the user's current page for use with marq questions
	def set_questionable
		session[:questionable_sid] = params[:id]
		session[:questionable_controller] = params[:controller]
		session[:questionable_url] = request.url
		session[:questionable_action] = params[:action]
	end

	# Override default behavior for testing on local machine 
	def remote_ip
		if request.remote_ip == '127.0.0.1'
			# Random remote address for testing on develop
			"#{rand(255)}.#{rand(255)}.#{rand(255)}.#{rand(255)}"
		else
			request.remote_ip
		end
	end

	def populate_tags model, *tags
		@tags = {}
		@selected_tags = {}
		tags.each do |tag|
			@tags[tag.to_s] = model.class.tag_counts_on(tag.to_sym).where("name like ?", "%#{params[:q]}%").map{|t| {:id => t.name, :name => t.name}}
			@selected_tags[tag.to_s] = model.send(tag.to_sym).map{|t| {:id => t.name, :name => t.name}}
		end
	end


private
	def miniprofiler
		Rack::MiniProfiler.authorize_request if current_user and current_user.admin?
	end

end
