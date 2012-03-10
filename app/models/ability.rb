class Ability
	include CanCan::Ability

	def initialize(user, params)
		# Define abilities for the passed in user here.

		user ||= User.new # guest user (not logged in)


		######################################################
		# Super Duper users
		######################################################
		if user.permissions >= 1024
			can :manage, :all
		end


		######################################################
		# Normal (confirmed) users
		######################################################
		if user.permissions >= 2
			# Images
			can [:create], Image do |image|
				# Requires all imageable models to implement an editors method
				# which returns a list of users who can edit it
				image.imageable.editors.include? user rescue false
			end

			can [:update], Image do |image|
				if image.user_id 
					user.id == image.user_id 
				elsif image.imageable
					image.imageable.editors.include? user rescue false	
				elsif image.imageable_id == nil && image.imageable_type != nil
					image.imageable_type.classify.constantize.find(params[:image][:imageable_id]).editors.include? user rescue false
				else
					false
				end
			end

			# Profiles
			can [:update], Profile do |profile|
				profile.user == user
			end


			# Projects
			can [:create], Project
			can [:update], Project do |project|
				# The user owns the project
				project.editors.include? user or 
					# The user is voting and only voting. current_user is filed in by the controller.
					(params[:project] ? (params[:project][:vote] && params[:project][:current_user_id] && params[:project].size == 2) : false)
			end


			# Users
			can :update, User do |usr|
				usr == user
			end
		end


		######################################################
		# Guest users & unconfirmed users
		######################################################
		if user.permissions >= 0
			can :read, Answer
			can :read, Profile
			can :read, Project
			can :read, Question
		end

		# Users
		cannot :destroy, User

		# Questions
		# No one can kill a question
		# cannot [:update], Question do |question|
		#	params[:question][:state_event] == 'kill' rescue false
		# end


		# The first argument to `can` is the action you are giving the user permission to do.
		# If you pass :manage it will apply to every action. Other common actions here are
		# :read, :create, :update and :destroy.
		#
		# The second argument is the resource the user can perform the action on. If you pass
		# :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
		#
		# The third argument is an optional hash of conditions to further filter the objects.
		# For example, here the user can only update published articles.
		#
		#   can :update, Article, :published => true
		#
		# See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities



		######################################################
		# Aliases
		######################################################
		alias_action :update, :destroy, :to => :modify



	end
end