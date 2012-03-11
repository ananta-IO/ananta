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
  attr_accessible :question, :questionable_url, :on => :create
  attr_accessible :vote, :state_event


  #########################
  # Associations
  #########################
  belongs_to :user 
  has_many :answers


  #########################
  # Validations
  #########################
  validates :user_id, :presence => true
  # validates :questionable_url, :presence => true
  validates :question, :presence => true, :length => { :in => 1..140 }, :uniqueness => {:scope => [:questionable_url]}
  

  #########################
  # Scopes
  #########################
  scope :published, where(:state => 'published')


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