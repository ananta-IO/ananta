# An Image can belong to anything
class Image < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  require 'file_size_validator'

  include Rails.application.routes.url_helpers
    
  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  #attr_reader
  attr_accessible :image, :remote_image_url, :image_type, :user_id, :imageable, :imageable_id, :imageable_type, :name, :lat, :lon


  #########################
  # Associations
  #########################
  belongs_to :user # The uploader/owner
  belongs_to :imageable, :polymorphic => true # The thing the image relates to -- Profiles, Projects, etc
  mount_uploader :image, ImageUploader


  #########################
  # Validations
  #########################
  #validates :user_id, :presence => true
  #validates :imageable_id, :presence => true
  validates :imageable_type,
            :presence => true
  validates :image_type,
            :presence => true
  validates :image,
            :presence => true,
            :file_size => {
              :maximum => 5.megabytes.to_i,
              :message => "file size too big. Please select a file less than 5MB."
            }

  #########################
  # Scopes
  #########################
  #scope :red, where(:color => 'red')


  #########################
  # Public Class Methods ( def self.method_name )
  #########################


  #########################
  # Public Instance Methods ( def method_name )
  #########################
  
  # One convenient method to pass jq_upload the necessary information
  def to_jq_upload
  {
    "id" => self.id,
    "name" => read_attribute(:image),
    "size" => image.size,
    "url" => image.url,
    "small_url" => image.small.url,
    "medium_url" => image.medium.url,
    "large_url" => image.medium.url,
    "delete_url" => image_path(:id => id),
    "delete_type" => "DELETE" 
   }
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
  
end