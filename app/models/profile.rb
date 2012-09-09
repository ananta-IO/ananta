# Every user has a profile
# Store personal data here
class Profile < ActiveRecord::Base
  include Gravtastic

  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  after_create :add_gravatar

  acts_as_ordered_taggable_on :bio, :seeking, :offering

  gravtastic :secure => false,
              :filetype => :jpg,
              :default => :identicon,
              :size => 1024

  # Versioning
  has_paper_trail

  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  attr_reader :bio_tokens, :seeking_tokens, :offering_tokens
  attr_accessible :name, :bio_tokens, :seeking_tokens, :offering_tokens, :gender, :date_of_birth


  #########################
  # Associations
  #########################
  extend FriendlyId
  friendly_id :slug #, :use => :slugged
  belongs_to :user
  has_many :images,   :as => :imageable, :dependent => :destroy
  has_many :avatars,  :as => :imageable, :source => :images, :class_name => "Image", :conditions => ["image_type = ?", "avatar"]
  has_many :pictures, :as => :imageable, :source => :images, :class_name => "Image", :conditions => ["image_type = ?", "picture"]
  has_many :views, :as => :viewable, :dependent => :destroy



  #########################
  # Validations
  #########################
  validates :name, :presence => true
  

  #########################
  # Scopes
  #########################
  #scope :red, where(:color => 'red')


  #########################
  # Public Class Methods ( def self.method_name )
  #########################

  ## One line description
  ## maybe two
  #def self.my_method
  #
  #end


  #########################
  # Public Instance Methods ( def method_name )
  #########################

  # Steal username from user
  def username
    self.user.username
  end

  # Steal email from user
  # mostly for Gravtastics benefit
  def email
    self.user.email
  end

  # Override default json representation
  def as_json(opts={})
    default_opts = { :methods => [ :avatar ] }
    default_opts = default_opts.merge! opts unless opts.blank?
    result = super(default_opts)
    result
  end

  # Current avatar Image
  def avatar
    current_avatar = avatars.last
    current_avatar ? current_avatar : Image.new(:imageable => self, :image_type => 'avatar')
  end

  # Helper for token_autocomplete
  def bio_tokens= ids
    self.bio_list = ids
  end

  # Helper for token_autocomplete
  def seeking_tokens= ids
    self.seeking_list = ids
  end

  # Helper for token_autocomplete
  def offering_tokens= ids
    self.offering_list = ids
  end

  # The users who may modify this model
  def editors
    editors = [self.user]
    editors
  end

  #########################
  # Protected Methods
  #########################
  protected

  # Same as Public Instance Methods


  #########################
  # Private Methods
  #########################
  private

  # Adds a gravatar if no avatar exists
  def add_gravatar
    if avatars && avatars.count == 0
      image = images.create({ image_type: 'avatar', user_id: user.id }) 
      image.update_attributes({ remote_image_url: gravatar_url, image_type: 'avatar', user_id: user.id })
    end
  end


end