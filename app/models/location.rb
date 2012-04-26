# A physical location
#
class Location < ActiveRecord::Base
  
  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.state   = geo.state
      obj.zipcode = geo.postal_code
      obj.country = geo.country_code
    end
  end

  after_validation :geocode, :if => Proc.new { |location| (location.city_changed? or location.state_changed? or !location.ip.nil? or location.street_changed? or location.zipcode_changed? or location.country_changed?) }
  after_validation :set_timezone, :if => Proc.new { |location| (location.timezone.blank? or location.latitude_changed? or location.longitude_changed?) }
  before_save :reverse_geocode, :if => Proc.new { |location| (location.latitude_changed? or location.longitude_changed?) }
  after_save :sync_locatable, :if => Proc.new { |location| location.locatable and (location.latitude_changed? or location.longitude_changed? or location.timezone_changed?) }


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  attr_accessor :ip
  attr_accessible :name, :street, :city, :state, :zipcode, :country


  #########################
  # Associations
  #########################
  belongs_to :locatable, :polymorphic => true


  #########################
  # Validations
  #########################
  validates :name, :presence => true
  validates :country, :presence => true
  validates :city, :presence => true, :if => Proc.new { |location| (location.latitude.blank? or location.longitude.blank?) and location.ip.nil? }
  validates :state, :presence => true, :if => Proc.new { |location| (location.latitude.blank? or location.longitude.blank?) and location.ip.nil? }


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

  def address
    self.ip || [street, city, state, zipcode, country].compact.join(', ')
  end

  def map_url
    "http://maps.google.com/maps?q=#{self.street},+#{self.city},+#{self.state},+#{self.zipcode}&hl=en"
  end


  #########################
  # Protected Methods
  #########################
  # protected

  # Same as Public Instance Methods


  #########################
  # Private Methods
  #########################
  private

  def set_timezone   
    begin
      # TODO: move this to a config file
      client = AskGeo.new(:account_id => '424004', :api_key => 'jstmdfns3e95odjv56hrgg79ak')

      response = client.lookup("#{self.latitude}, #{self.longitude}")
      tz = response["timeZone"]
      self.timezone = tz
    rescue AskGeo::APIError => e
      # Default to EST/EDT
      self.timezone = "America/New_York"
    end
  end

  def sync_locatable
    obj = self.locatable
    %w(latitude longitude timezone).each do |a|
      obj[a.to_sym] = self[a.to_sym]
   end
    obj.save
  end

end
