# class UserCreationService
#	def initialize(user_klass = User)
#		@user_klass = user_klass
#	end

#	def create(attributes)
#		user = @user_klass.new 
#		user.assign_attributes(attributes)
#		initialize_profile user
#		initialize_permissions user
#		user.save!

#		user.sync_slug if user.username != user.profile.slug
#		user.generate_username unless user.username?

#		user
#	end

#	private

#	def initialize_profile user
#		if user.profile.blank?
#			user.build_profile(:name => user.email_to_name) 
#		elsif user.profile.name.blank?
#			user.profile.name = user.email_to_name
#		end
#	end

#	def initialize_permissions user
#		user.permissions = 2 
#	end
# end