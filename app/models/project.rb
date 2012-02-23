class Project < ActiveRecord::Base
  #########################
  # Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  #acts_as_...


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  #attr_reader
  attr_accessible :name, :description, :state
  #attr_protected


  #########################
  # Associations
  #########################
  #belongs_to
  #has_one
  #has_many


  #########################
  # Validations
  #########################
  #validates :attribute  # use validates syntax instead of validates_uniqueness_of...


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

  ## One line description
  ## maybe two
  #def my_method
  #
  #end


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
