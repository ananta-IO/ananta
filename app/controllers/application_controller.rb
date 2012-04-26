class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :set_questionable, :if =>  lambda { request.format == 'html' }

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  # Devise after sign in hack     # TODO: make less hacky, maybe update the /users route?
  def after_sign_in_path_for(resource)
    request.referer =~ /\/users/ ? root_url : super
  end

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

  def set_questionable
    session[:questionable_sid] = params[:id]
    session[:questionable_controller] = params[:controller]
    session[:questionable_url] = request.url
    session[:questionable_action] = params[:action]
  end

  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Random remote address for testing on develop
      "#{rand(255)}.#{rand(255)}.#{rand(255)}.#{rand(255)}"
    else
      request.remote_ip
    end
  end
end
