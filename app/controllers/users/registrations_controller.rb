class Users::RegistrationsController < Devise::RegistrationsController

  def create
    build_resource

    l = resource.locations.new
    l.ip = remote_ip

    if fb_user = session[:facebook_user_attributes]
      resource.facebook_id = fb_user.id  #, locale: fb_user.locale, facebook_verified: fb_user.verified 
      resource.build_profile(:name => fb_user.name) 
      resource.profile.images.new({ remote_image_url: "https://graph.facebook.com/#{fb_user.id}/picture?type=large", image_type: 'avatar' })
    end
    if project = params[:project]
      resource.projects.new project
    end

    if resource.save
      analytical.identify(resource.id, { name: resource.username } )
      analytical.event 'Successful User Registration', { email: resource.email, username: resource.username }
      session.delete(:facebook_user_attributes) if session[:facebook_user_attributes]
      if resource.active_for_authentication?
        set_flash_message(:notice, :signed_up)
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message(:notice, :"signed_up_but_#{resource.inactive_message}")
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource, :location => 'users/registrations/new'
    end
  end

end