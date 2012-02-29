# Every user has a profile
# Store personal data here
class Profile < ActiveRecord::Base

  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  acts_as_taggable_on :bio_tags, :skills, :needs


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  attr_reader :bio_tokens
  attr_reader :skill_tokens
  attr_reader :need_tokens
  attr_accessible :name, :bio_tokens, :skill_tokens, :need_tokens
  #attr_protected


  #########################
  # Associations
  #########################
  extend FriendlyId
  friendly_id :username, :use => :slugged
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

  # Steal username from user
  def username
    self.user.username
  end

  # Helper for token_autocomplete
  def bio_tokens= ids
    self.bio_tag_list = ids
  end

  # Helper for token_autocomplete
  def skill_tokens= ids
    self.skill_list = ids
  end

  # Helper for token_autocomplete
  def need_tokens= ids
    self.need_list = ids
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