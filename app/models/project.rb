# This canonical record is the foundation of the site
# Everything revolves around projects and making them better
#

require File.join(Rails.root, 'lib/ananta/vote')

class Project < ActiveRecord::Base
  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  include Ananta::Vote

  acts_as_taggable_on :tags
  acts_as_voteable

  # Project state machine
  state_machine :initial => :brainstoming do
    event :plan do
      transition :brainstoming => :planning
    end

    event :work do
      transition :planning => :working
    end

    event :check_done do
      transition :working => :completing
    end

    event :not_done do
      transition :completing => :working
    end

    event :done do
      transition :completing => :complete
    end

    event :kill do
      transition [:brainstoming, :planning, :working, :completing] => :killed
    end
  end


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  attr_reader :tag_tokens, :cast_vote
  attr_accessible :name, :description, :state_event, :tag_tokens, :cast_vote


  #########################
  # Associations
  #########################
  extend FriendlyId
  friendly_id :name, :use => :slugged
  belongs_to :user
  has_many   :images,   :as => :imageable, :dependent => :destroy
  has_many   :avatars,  :as => :imageable, :source => :images, :class_name => "Image", :conditions => ["image_type = ?", "avatar"]
  has_many   :pictures, :as => :imageable, :source => :images, :class_name => "Image", :conditions => ["image_type = ?", "picture"]



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
