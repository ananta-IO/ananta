# Store registration information here
# All other info should be in linked models
class User < ActiveRecord::Base

	#########################
	# Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
	#########################
	after_validation	:validate_reserved
	before_create   	:before_create
	after_save      	:sync_slug, :if => Proc.new { |user| user.slug != user.profile.slug }
	
	# Include default devise modules. Others available are:
	# :encryptable, :confirmable
	devise :database_authenticatable, :registerable,
				 :recoverable, :rememberable, :trackable, :validatable,
				 :token_authenticatable,
				 :lockable, :timeoutable, :omniauthable

	# Voting
	acts_as_voter
	has_karma(:projects, :as => :user, :weight => 1.0) # votable, foreign_key, weight


	#########################
	# Setup attributes (reader, accessible, protected)
	#########################
	#attr_reader
	attr_accessor :login
	attr_accessible :username, :login, :email, :password, :password_confirmation, :remember_me, :facebook_id


	#########################
	# Associations
	#########################
	extend FriendlyId
	friendly_id		:username
	has_one    		:profile, :dependent => :destroy
	# has_one  		:account, :dependent => :destroy				# TODO: ?
	has_many   		:projects
	# has_many 		:project_memberships
	# has_many 		:joined_projects, :class_name => 'Project', :through => :project_memberships
	# has_many 		:team_memberships                    		# TODO: ?
	# has_many 		:teams, :through => :team_memberships		# TODO: ?
	has_many   		:images
	has_many   		:questions
	has_many   		:answers

	accepts_nested_attributes_for :profile


	#########################
	# Validations
	#########################
	validates :username, :uniqueness => true, :length => 3..63 #, :allow_blank => true
	validate  :valid_username_format
	# TODO: a user should not be able to register without a project


	#########################
	# Scopes
	#########################
	#scope :red, where(:color => 'red')


	#########################
	# Public Class Methods ( def self.method_name )
	#########################

	# Authenticate with email or username
	def self.find_for_database_authentication(warden_conditions)
		conditions = warden_conditions.dup
		login = conditions.delete(:login)
		where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
	end

	# Given facebook authentication data, find the user record
	def self.find_for_facebook(fb_user, current_user=nil)
		if current_user
			current_user.update_attribute(:facebook_id, fb_user.id) if current_user.facebook_id != fb_user.id
			current_user
		elsif user = User.find_by_facebook_id(fb_user.id)
			user
		elsif user = User.find_by_email(fb_user.email.downcase)
			user.update_attribute(:facebook_id, fb_user.id)
			user.profile.images.create({ remote_image_url: "https://graph.facebook.com/#{fb_user.id}/picture?type=large", image_type: 'avatar' }) if user.profile.avatars.count == 0
			user
		else # Create a user
			passwd = Devise.friendly_token + Devise.friendly_token
			user = User.new({ email: fb_user.email.downcase, facebook_id: fb_user.id, name: fb_user.name, password: passwd, password_confirmation: passwd })
			user.profile.images.new({ remote_image_url: "https://graph.facebook.com/#{fb_user.id}/picture?type=large", image_type: 'avatar' })
			user
		end
	end


	#########################
	# Public Instance Methods ( def method_name )
	#########################

	# Override destroy
	def destroy
		# Do nothing
	end

	def name
		profile.name
	end

	def first_name
		self.name.split(" ").first
	end

	def last_name
		self.name.split(" ").last
	end

	# The users who may modify this model
	def editors
		editors = [self]
		editors
	end
	

	#########################
	# Protected Methods
	#########################
	protected


	#########################
	# Private Methods
	#########################
	private

	# Callbacks

	# Check if username is a reserved word
	def validate_reserved
		if errors[:friendly_id].present?
			errors[:username] = "is reserved. Please choose something else."
			errors.messages.delete(:friendly_id)
		end
	end

	# Build a profile for the new user
	def before_create
		# Derives a default name from the user's email if no name is passed
		name = email.split("@").first.split(/[\-\_\.]/).reduce{ |full_name, name| full_name = "#{full_name} #{name}" }.titleize rescue ""
		build_profile(:name => name)

		# Set the permissions for a new user
		self.permissions = 2 
	end

	# Sync profile slug with user slug
	def sync_slug
		p = profile
		p.slug = slug
		p.save
	end

	# Validations

	# Check the username format
	def valid_username_format
		unless username =~ /^[A-Za-z-]*$/i or username == id.to_s
			errors.add(:username, "only letters and hyphens allowed")
		end
	end

end
