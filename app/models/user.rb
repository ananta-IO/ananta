class User < ActiveRecord::Base

  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  after_validation :validate_reserved
  after_create :after_create
  after_save :sync_slug, :if => Proc.new { |user| user.slug != user.profile.slug }
  
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
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :facebook_id
  #attr_protected


  #########################
  # Associations
  #########################
  extend FriendlyId
  friendly_id :username#, :use => :slugged
  has_one :profile, :dependent => :destroy


  #########################
  # Validations
  #########################
  validates :profile, :presence => true
  validates :username, :uniqueness => true, :length => 3..63, :allow_blank => true
  validate  :valid_username_format

  #########################
  # Scopes
  #########################
  #scope :red, where(:color => 'red')


  #########################
  # Public Class Methods ( def self.method_name )
  #########################

  # New method, sets the name based on the email address
  def self.new attr = {}
    attr[:username] ||= "IHATEUSERNAMES#{rand(1000000000).to_s}"
    u = super attr

    # derives a default name from the user's email if no name is passed
    attr[:name] = attr[:email].split("@").first.split(/[\_\.]/).reduce{ |full_name, name| full_name = "#{full_name} #{name}" }.titleize if attr[:name].nil? rescue ""
    u.build_profile(:name => attr[:name])
    u
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

  # Callbacks

  # Check if username is a reserved word
  def validate_reserved
    if @errors[:friendly_id].present?
      @errors[:username] = "is reserved. Please choose something else"
      @errors.messages.delete(:friendly_id)
    end
  end

  # Sets the default permission level for a new user
  def after_create
    # set the permissions of a newly confirmed user
    self.permissions = 2 # ability model will not work if this is set in new()
    self.save

    initialize_username
  end

  def initialize_username
    if self.username =~ /IHATEUSERNAMES/
      self.username = self.id.to_s
      self.save!
    end
  end

  def username_editable?
    (self.username.first =~ /[0-9]/ && self.username.to_i == self.id ) or self.username_changed?
  end

  def sync_slug
    p = self.profile
    p.slug = self.slug
    p.save
  end

  # Validations

  # Check the username format
  def valid_username_format
    unless self.username =~ /^[A-Za-z_-][A-Za-z0-9_-]*$/i or self.username = self.id.to_s
      self.errors.add(:username, "Only letters, numbers, hyphens and underscores allowed. Usernames may not start with a number.")
    end
  end


  #########################
  # Private Methods
  #########################
  private

  # Same as Public Instance Methods

end
