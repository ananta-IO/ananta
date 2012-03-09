# A question must be binary (yes, no)
# It can be answered with Yes, No, Don't Care. 
# The questions with more Yes, No answers and fewer Don't Cares get displayed more.
class Question < ActiveRecord::Base

  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  # flag or vote up
  acts_as_voteable

  # Question state machine
  state_machine :initial => :published do
    event :unpublish do
      transition :published => :unpublished
    end

    event :publish do
      transition :unpublished => :published
    end

    # Only moderaters should be allowed to kill a question
    # Check ability model
    event :kill do
      transition [:published, :unpublished] => :killed
    end
  end

  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  #attr_reader
  #attr_accessor
  attr_accessible :question, :vote, :state_event


  #########################
  # Associations
  #########################
  extend FriendlyId
  friendly_id :question, :use => :slugged
  belongs_to :user 
  belongs_to :questionable, :polymorphic => true
  has_many :answers


  #########################
  # Validations
  #########################
  validates :question, :presence => true, :length => { :in => 1..140 }, :uniqueness => {:scope => [:questionable_id, :questionable_type]}
  # validates :questionable_id, :allow_blank => true
  # validates :questionable_type, :allow_blank => true
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