# An answer to a question may be submitted by anyone, logged in or not 
# generally takes the form or Yes No or Don't Care, but may be elaborated on
#
class Answer < ActiveRecord::Base

  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################

  # Answer state machine
  state_machine :initial => :unanswered do
    event :ans_yes do
      transition :unanswered => :yes
    end

    event :ans_no do
      transition :unanswered => :no
    end

    event :ans_dont_care do
      transition :unanswered => :dont_care
    end
  end


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  #attr_reader
  #attr_accessor
  #attr_accessible


  #########################
  # Associations
  #########################
  belongs_to :user 
  belongs_to :question


  #########################
  # Validations
  #########################
  validates :user_id, :pressence => true


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