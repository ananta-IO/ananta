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
    after_transition :on => :ans_yes, :do => :increment_yes_count

    event :ans_no do
      transition :unanswered => :no
    end
    after_transition :on => :ans_no, :do => :increment_no_count

    event :ans_dont_care do
      transition :unanswered => :dont_care
    end
    after_transition :on => :ans_dont_care, :do => :increment_dont_care_count
  end


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  #attr_reader
  #attr_accessor
  attr_accessible :state_event, :comment_attributes, :user_id, :on => :create


  #########################
  # Associations
  #########################
  belongs_to :user 
  belongs_to :question
  has_many :comment, :as => :commentable, :dependent => :destroy

  accepts_nested_attributes_for :comment


  #########################
  # Validations
  #########################
  validates :user_id, :presence => true
  validates :question_id, :presence => true, :uniqueness => {:scope => :user_id, :message => "has already been answered by you"}
  # validates :comment, :length => { :in => 1..140 }, :allow_blank => true
  validate :validate_state, :on => :create


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

  # Increment the question's yes counters
  def increment_yes_count
    Question.increment_counter(:yes_count, self.question_id)
    true
  end

  # Increment the question's no counters
  def increment_no_count
    Question.increment_counter(:no_count, self.question_id)
    true
  end

  # Increment the question's don't care counters
  def increment_dont_care_count
    Question.increment_counter(:dont_care_count, self.question_id)
    true
  end

  # Check if the state_event is acceptable
  def validate_state
    errors.add(:state, "must be yes, no or don't care") unless state_changed? and %w(yes no dont_care).include? changes['state'][1]
  end 


  #########################
  # Private Methods
  #########################
  private

  # Same as Public Instance Methods


end