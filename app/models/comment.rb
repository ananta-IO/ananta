# One or two line description of what the model represents
#
#
class Comment < ActiveRecord::Base

  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  acts_as_voteable
  acts_as_taggable


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  #attr_reader
  #attr_accessor
  # Make sure all controllers that create comments define user_id = current_user.id
  attr_accessible :comment, :user_id, :on => :create


  #########################
  # Associations
  #########################
  belongs_to :user
  belongs_to :commentable, :polymorphic => true


  #########################
  # Validations
  #########################
  # validates :user_id, :presence => true
  # validates :commentable_id, :presence => true
  # validates :commentable_type, :presence => true
  validates :comment, :presence => true, :length => { :in => 1..65535 }


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

  # Same as Public Instance Methods


end