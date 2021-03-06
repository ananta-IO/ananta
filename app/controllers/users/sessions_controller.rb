class Users::SessionsController < Devise::SessionsController
	def create
		resource = warden.authenticate!(auth_options)
		set_flash_message(:notice, :signed_in)
		sign_in(resource_name, resource)
		analytical.identify( resource.id, { name: resource.username })
		analytical.event 'Successful Email & Password Login', { username: resource.username }
		@user = resource
		respond_with @user, :location => after_sign_in_path_for(@user)
	end
end