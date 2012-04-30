# This canonical record is the foundation of the site
# Everything revolves around projects and making them better
#

require File.join(Rails.root, 'lib/ananta/vote')

class Project < ActiveRecord::Base
  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  include Ananta::Vote

  has_paper_trail # TODO: add tags to versioning, exclude name (i.e. friendly_id) from version
  acts_as_taggable_on :tags
  acts_as_voteable

  # Project state machine
  state_machine :initial => :planning do
    event :work do
      transition :planning => :working
    end

    event :check_complete do
      transition :working => :completing
    end

    event :not_complete do
      transition :completing => :working
    end

    event :complete do
      transition :completing => :complete
    end

    event :kill do
      transition [:planning, :working, :completing] => :killed
    end
  end


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
  belongs_to :user
  has_one    :location, :as => :locatable, :dependent => :destroy
  has_many   :images,   :as => :imageable, :dependent => :destroy
  has_many   :avatars,  :as => :imageable, :source => :images, :class_name => "Image", :conditions => ["image_type = ?", "avatar"]
  has_many   :pictures, :as => :imageable, :source => :images, :class_name => "Image", :conditions => ["image_type = ?", "picture"]

  accepts_nested_attributes_for :location


  #########################
  # Validations
  #########################
  validates :name, 
    :presence => true, 
    :uniqueness => {:scope => :user_id, :message => "cannot be the same as one of your other projects."},
    :length => { :minimum => 3, :maximum => 141, :too_short => "Please say a little more. 3 characters minimum.", :too_long => "Please say a little less. 141 characters maximum." } # TODO: find out why this causes problems with migrations
  validates :user_id, :presence => true


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

  #########################
  # Protected Methods
  #########################
  protected


  #########################
  # Private Methods
  #########################
  private


end
