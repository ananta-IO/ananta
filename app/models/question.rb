# A question must be binary (yes, no)
# It can be answered with Yes, No, Don't Care. 
# The questions with more Yes, No answers and fewer Don't Cares get displayed more.

require File.join(Rails.root, 'lib/ananta/vote')

class Question < ActiveRecord::Base

  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  include Ananta::Vote

  before_save :update_answer_count, :if => :answer_counts_changed?

  # Vote
  acts_as_voteable 

  # TODOooooooooo: add relevance. to be queried in a 0-1000 range slider after every answer is submited. saved as question_relevance on answer and averaged in a worker and stored on quesiton as avg_relevance. bias the ui to users with really nice track pads ;) and increase relevence by the durration and vigor with which a user rubs an answered question, make the question heat up (dark to red) as the user rubs. AND HAVE SPARKS COME OUT WHEN A QUESTION GETS RED HOT! Do not count the relevance of the user who created the question towards the average

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
  attr_accessible :question, :questionable_url, :questionable_sid, :questionable_controller, :questionable_action, :on => :create
  attr_accessible :cast_vote, :state_event


  #########################
  # Associations
  #########################
  belongs_to :user 
  has_many :answers, :dependent => :destroy
  has_many :comments, :through => :answers, :source => :comment


  #########################
  # Validations
  #########################
  validates :user_id, :presence => true
  # validates :questionable_url, :presence => true
  validates :question, :presence => true, :length => { :in => 15..141 }, :uniqueness => {:scope => [:questionable_url]}, :format => { :with => /\?$/, :message => "must end with question mark (?)" }
  

  #########################
  # Scopes
  #########################
  scope :published, where(:state => 'published')
  scope :answered, where("answer_count > ?", 0)
  scope :answered_by, lambda { |user_id| joins(:answers).where("answers.user_id = ?", user_id)}
  scope :unanswered, where("answer_count = ?", 0)
  scope :unanswered_by, lambda { |user_id| where( "answer_count = ? OR id NOT IN (?)", 0, ( [0] | ( User.find(user_id).answers.pluck(:question_id) rescue [] ) ) ) }
  scope :q_url, lambda { |q_url| where("questionable_url LIKE ?", "%#{q_url}%") } 
  scope :q_sid, lambda { |q_sid| where("questionable_sid = ?", q_sid) } 
  scope :q_controller, lambda { |q_con| where("questionable_controller = ?", q_con) } 
  scope :q_action, lambda { |q_act| where("questionable_action = ?", q_act) } 

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

  # Similar to the scope, but for the current record
  def answered_by user_id
    answers.where("user_id = ?", user_id).first
  end

  #########################
  # Protected Methods
  #########################
  protected

  # Return true if any of the answer counts change
  def answer_counts_changed?
    if yes_count_changed? or no_count_changed? or dont_care_count_changed?
      true
    else
      false
    end
  end

  # Increment or decrement answer_count
  def update_answer_count
    c = 0
    c = c + changes[:yes_count][1] - changes[:yes_count][0] if yes_count_changed?
    c = c + changes[:no_count][1] - changes[:no_count][0] if no_count_changed?
    c = c + changes[:dont_care_count][1] - changes[:dont_care_count][0] if dont_care_count_changed?
    self.answer_count = self.answer_count + c
  end


  #########################
  # Private Methods
  #########################
  private

  # Same as Public Instance Methods


end