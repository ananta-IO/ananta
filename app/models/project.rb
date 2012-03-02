class Project < ActiveRecord::Base
  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
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
  attr_reader :tag_tokens, :vote
  attr_accessible :name, :description, :state_action, :tag_tokens, :vote
  #attr_protected


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

  # Extend to handle voting
  def update_attributes opts={}
    # Loving and Flaging = Voting
    vote(opts) if opts[:vote]

    # Sanitize the hash
    opts.delete :vote if opts[:vote] 
    opts.delete :current_user_id if opts[:current_user_id]

    # Super
    super opts
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

  # Update Methods

  # Cast a vote on this project i.e. Love or Flag
  def vote opts
    case opts[:vote]
    when 'for'
      vote = "vote_exclusively_for"
    when 'against'
      vote = "vote_exclusively_against"
    when 'cancel'
      vote = "unvote_for"
    end
    User.find(opts[:current_user_id]).send(vote, self) rescue nil
  end


end
