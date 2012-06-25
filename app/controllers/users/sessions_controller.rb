class Users::SessionsController < Devise::SessionsController
	def create
		resource = warden.authenticate!(auth_options)
		set_flash_message(:notice, :signed_in)
		sign_in(resource_name, resource)
		analytical.identify(resource.id, :email=>resource.email)
		analytical.event 'Form Login', with: { id: resource.id, name: resource.name, username: resource.username }
		@user = resource
		respond_with @user, :location => after_sign_in_path_for(@user)
	end
end