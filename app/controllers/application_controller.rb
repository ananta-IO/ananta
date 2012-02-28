class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  # Devise after sign in hack     # TODO: make less hacky, maybe update the /users route?
  def after_sign_in_path_for(resource)
    request.referer == "/users" ? redirect_to(root_url) : super
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
end
