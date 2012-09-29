# Store registration information here
# All other info should be in linked models
class User < ActiveRecord::Base

	#########################
	# Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
	#########################
	after_validation    :validate_username_reserved
	before_create do
		initialize_profile
		initialize_permissions      
	end
	after_save do   
		sync_slug if username != profile.slug
		generate_username unless username?
	end

	# Include default devise modules. Others available are:
	# :encryptable, :confirmable, :token_authenticatable
	devise :database_authenticatable, :registerable,
		   :recoverable, :rememberable, :trackable, :validatable,
		   :lockable, :timeoutable, :omniauthable

	# Voting
	acts_as_voter
	has_karma(:projects, :as => :user, :weight => 1.0) # votable, foreign_key, weight

	# Geocoder
	geocoded_by nil, :latitude => :lat, :longitude => :lng

	# Versioning
	has_paper_trail
	

	#########################
	# Setup attributes (reader, accessible, protected)
	#########################
	#attr_reader
	attr_accessor :login, :project_name
	attr_accessible :username, :login, :email, :password, :password_confirmation, :remember_me, :facebook_id
	attr_accessible :project_name, on: :create


	#########################
	# Associations
	#########################
	extend FriendlyId
	friendly_id     :username
	has_one         :profile, :dependent => :destroy
	# has_one       :account, :dependent => :destroy                # TODO: ?
	has_many        :locations, :as => :locatable, :dependent => :destroy
	has_many        :projects, :dependent => :destroy
	# has_many      :project_memberships
	# has_many      :joined_projects, :class_name => 'Project', :through => :project_memberships
	# has_many      :team_memberships                           # TODO: ?
	# has_many      :teams, :through => :team_memberships       # TODO: ?
	has_many        :images, :dependent => :destroy
	has_many        :questions, :dependent => :destroy
	has_many        :answers, :dependent => :destroy
	has_many		:views
	has_many		:comments

	accepts_nested_attributes_for :profile


	#########################
	# Validations
	#########################
	validates :username, :uniqueness => {:case_sensitive => false}, :length => 1..20, :allow_blank => true, :if => Proc.new { |user| user.username != user.id.to_s }
	validate  :validate_username_format
	validate  :validate_has_a_project, on: :create


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
			if user.profile.avatars.count == 0
				# TODO: UNHACK: This is a hack. I don't know how to store the model's attributes before processing the image in the uploader. This proccesses twice, the first time with no image. 
				image = user.profile.images.new({ image_type: 'avatar' })
				image.update_attributes({ remote_image_url: "https://graph.facebook.com/#{fb_user.id}/picture?type=large", image_type: 'avatar' })
			end
			user
		else # Create a user. This should never get persisted. The user should confirm the info and fb data should be synced on registration.
			user = User.new({ email: fb_user.email.downcase, facebook_id: fb_user.id, username: fb_user.username })
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
		name.split(" ").first
	end

	def last_name
		name.split(" ").last
	end

	# Current location
	def location
		current_location = locations.last
		current_location ? current_location : nil
	end

	def address
		location.address if location
	end

	def avatar
		profile.avatar
	end

	def editors
		editors = [self]
		editors
	end

	def project_name= name
		self.projects.new(name: name)
	end

	def email_to_name
		email.split("@").first.split(/[\-\_\.]/).reduce{ |full_name, name| full_name = "#{full_name} #{name}" }.titleize rescue ""
	end

	# TODO: implement reputation
	def reputation
		7
	end

	def admin?
		self.permissions >= 1024
	end
	

	#########################
	# Protected Methods
	#########################
protected


	#########################
	# Private Methods
	#########################
private

	def validate_username_reserved
		if errors[:friendly_id].present?
			errors[:username] = "is reserved. Please choose something else."
			errors.messages.delete(:friendly_id)
		end
	end

	def initialize_profile
		if profile.blank?
			build_profile(:name => email_to_name) 
		elsif profile.name.blank?
			profile.name = email_to_name
		end
	end

	def initialize_permissions
		self.permissions = 2 
	end

	def sync_slug
		profile.update_attribute(:slug, username)
	end

	def generate_username
		self.update_attribute(:username, self.id.to_s)  
	end

	def validate_username_format
		unless username =~ /^[a-zA-Z][a-zA-Z0-9_]*$/ or username == id.to_s
			errors.add(:username, "may only contain letters, numbers and underscores")
		end
	end

	def validate_has_a_project
		errors.add(:project_name, "must be between 3 and 141 characters") unless self.projects.any? and self.projects.first.valid?
	end

end
