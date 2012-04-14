class Users::RegistrationsController < Devise::RegistrationsController

  def create
    # r_name = resource.class.to_s.downcase
    # params[r_name][:password_confirmation] = params[r_name][:password] if params[r_name][:password_confirmation].blank?
    build_resource

    Rails.logger.debug
    Rails.logger.debug ">>>>>>>>"
    Rails.logger.debug resource.inspect
    Rails.logger.debug session.inspect
    Rails.logger.debug ">>"
    Rails.logger.debug params.inspect

    # resource = add_facebook_attributes resource if session[:facebook_user_attributes]


    if resource.save
      # resource = add_facebook_attributes resource if session[:facebook_user_attributes]
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource, :location => 'users/registrations/new'
    end
  end

  private

  def add_facebook_attributes resource
    fb_user = session[:facebook_user_attributes]
    resource.facebook_id = fb_user.id  #, locale: fb_user.locale, timezone: fb_user.timezone, facebook_verified: fb_user.verified 
    resource.build_profile(:name => "carl") 
    resource.profile.images.new({ remote_image_url: "https://graph.facebook.com/#{fb_user.id}/picture?type=large", image_type: 'avatar' })
    resource
  end

end