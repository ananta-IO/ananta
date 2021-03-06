# This canonical record is the foundation of the site
# Everything revolves around projects and making them better
#

# require File.join(Rails.root, 'lib/ananta/vote')

class Project < ActiveRecord::Base
  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  include Ananta::Vote

  has_paper_trail # TODO: add tags to versioning, exclude name (i.e. friendly_id) from version
  acts_as_ordered_taggable_on :tags
  acts_as_voteable

  # Project state machine
  # TODO: Remove State Machine from the whole app.
  state_machine :initial => :draft do

    event :validate do # Is this project worth pursuing?
      transition :draft => :validating
    end

    # event :learn do # What do I need to know about this project to make it a success?
    #   transition :validating => :learning
    # end

    event :design do # Who do I need on my team? What is our plan? What are our expectations?
      transition :validating => :designing 
    end

    event :build do # If communications is key, are we communicating enough?
      transition :designing => :building
    end

    event :check_complete do
      transition :building => :completing
    end

    event :not_complete do
      transition :completing => :building
    end

    event :complete do
      transition :completing => :complete
    end

    event :kill do
      transition [:draft, :validating, :learning, :designing, :building, :completing] => :killed
    end
  end

  # Geocoder
  geocoded_by nil, :latitude => :lat, :longitude => :lng

  # Callbacks
  after_create :after_create


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  # attr_reader :cast_vote
  attr_accessor :tag_tokens
  attr_accessible :name, :description, :state_event, :tag_tokens, :cast_vote


  #########################
  # Associations
  #########################
  extend FriendlyId
  friendly_id :name, :use => :slugged

  belongs_to :user,            :counter_cache => true
  has_many   :project_memberships, :dependent => :destroy
  has_many   :pending_memberships, :source => :project_memberships, :class_name => 'ProjectMembership', :conditions => ["state = ?", "pending"]
  has_many   :pending_members, :source => :user, :class_name => 'User', :through => :project_memberships, :conditions => ["state = ?", "pending"]
  has_many   :members,         :source => :user, :class_name => 'User', :through => :project_memberships, :conditions => ["state = ?", "accepted"]
  has_many   :participants,    :through => :comments, :source => :user, :class_name => 'User', :uniq => true
  has_one    :location,        :as => :locatable, :dependent => :destroy
  has_many   :images,          :as => :imageable, :dependent => :destroy
  has_many   :avatars,         :as => :imageable, :source => :images, :class_name => "Image", :conditions => ["image_type = ?", "avatar"]
  has_many   :pictures,        :as => :imageable, :source => :images, :class_name => "Image", :conditions => ["image_type = ?", "picture"]
  has_many   :views,           :as => :viewable,  :dependent => :destroy
  has_many   :comments,        :as => :commentable, :dependent => :destroy
  has_many   :notifications,   :as => :notifiable, :dependent => :destroy

  accepts_nested_attributes_for :location


  #########################
  # Validations
  #########################
  validates :name,
    :uniqueness => {:scope => :user_id, :message => "cannot be the same as one of your other projects"},
    :length => { :minimum => 3, :maximum => 141, :too_short => "is too short, please say a little more", :too_long => "is too long, please say a little less (141 characters max)" } # TODO: find out why this causes problems with migrations
  before_destroy :validate_not_last_project


  #########################
  # Scopes
  #########################
  # scope :red, where(:color => 'red')


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

  # Current avatar Image
  def avatar
    current_avatar = avatars.last
    current_avatar ? current_avatar : Image.new(:imageable => self, :image_type => 'avatar')
  end
  
  # Helper for token_autocomplete
  def tag_tokens= ids
    self.tag_list = ids
  end

  # The users who may modify this model
  def editors
    editors = [self.user]
    editors
  end

  def energy
    3
  end

  def followers
    self.votes.where(vote:true, voter_type:'User').map{|v| v.voter}
  end


  #########################
  # Protected Methods
  #########################
  protected
  

  #########################
  # Private Methods
  #########################
  private

  def validate_not_last_project
    if self.user.projects.count > 1
      true
    else
      errors.add(:project, "is your last. You cannot delete this project until you create another one.")
      false
    end
  end

  def after_create
    self.user.vote_exclusively_for(self)
  end

end
