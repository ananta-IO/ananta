class User < ActiveRecord::Base

	#########################
	# Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
	#########################
	after_validation	:validate_reserved
	before_create   	:before_create
	after_create    	:after_create
	after_save      	:sync_slug, :if => Proc.new { |user| user.slug != user.profile.slug }
	
	# Include default devise modules. Others available are:
	# :encryptable, :confirmable
	devise :database_authenticatable, :registerable,
				 :recoverable, :rememberable, :trackable, :validatable,
				 :token_authenticatable,
				 :lockable, :timeoutable, :omniauthable

	#########################
	# Setup attributes (reader, accessible, protected)
	#########################
	#attr_reader
	attr_accessible :password, :password_confirmation, :remember_me, :facebook_id
	attr_accessible :username, :email, :on => :create
	#attr_protected


	#########################
	# Associations
	#########################
	extend FriendlyId
	friendly_id		:username
	has_one    		:profile, :dependent => :destroy
	has_many   		:projects


	#########################
	# Validations
	#########################
	validates :profile, :presence => true
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

	# TODO: use jbuilder
	def as_json(opts={})
		default_opts = {:only => [:id, :email, :name], :include => { :profile => { :methods => :avatar }  }}
		default_opts = default_opts.merge! opts unless opts.blank?
		results = super(default_opts)
		results
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
			errors[:username] = "is reserved. Please choose something else"
			errors.messages.delete(:friendly_id)
		end
	end

	# Build a profile for the new user
	def before_create
		# derives a default name from the user's email if no name is passed
		name = email.split("@").first.split(/[\_\.]/).reduce{ |full_name, name| full_name = "#{full_name} #{name}" }.titleize if attr[:name].nil? rescue ""
		build_profile(:name => name)	
	end

	# Sets the default permission level for a new user
	def after_create
		# set the permissions of a newly confirmed user
		permissions = 2 # ability model will not work if this is set in new()
		save
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
			errors.add(:username, "only letters and hyphens allowed.")
		end
	end

end