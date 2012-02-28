class Project < ActiveRecord::Base
  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  acts_as_taggable_on :tags

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
  #attr_reader
  attr_accessible :name, :description, :state_action, :tag_tokens
  #attr_protected
  attr_reader :tag_tokens


  #########################
  # Associations
  #########################
  extend FriendlyId
  friendly_id :name, :use => :slugged
  belongs_to :user


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

  # Helper for token_autocomplete
  def tag_tokens= ids
    self.tag_list = ids
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

  # Same as Public Instance Methods
end
