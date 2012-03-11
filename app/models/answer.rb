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
    after_transition :on => :ans_yes, :do => :increment_yeses

    event :ans_no do
      transition :unanswered => :no
    end
    after_transition :on => :ans_no, :do => :increment_noes

    event :ans_dont_care do
      transition :unanswered => :dont_care
    end
    after_transition :on => :ans_dont_care, :do => :increment_dont_cares
  end


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  #attr_reader
  #attr_accessor
  attr_accessible :state_event, :comment


  #########################
  # Associations
  #########################
  belongs_to :user 
  belongs_to :question


  #########################
  # Validations
  #########################
  validates :user_id, :presence => true
  validates :question_id, :presence => true
  validates :comment, :length => { :in => 1..140 }, :allow_blank => true


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
  def increment_yeses
    Question.increment_counter(:yeses, self.question_id)
    true
  end

  # Increment the question's no counters
  def increment_noes
    Question.increment_counter(:noes, self.question_id)
    true
  end

  # Increment the question's don't care counters
  def increment_dont_cares
    Question.increment_counter(:dont_cares, self.question_id)
    true
  end


  #########################
  # Private Methods
  #########################
  private

  # Same as Public Instance Methods


end