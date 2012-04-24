# A physical location
#
class Location < ActiveRecord::Base
  
  #########################
  # Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
  #########################
  geocoded_by :full_street_address
  # reverse_geocoded_by :latitude, :longitude

  before_validation Proc.new { |location| location.name = 'default' }, :if => Proc.new { |location| location.name.blank? }
  after_validation :geocode, :if => Proc.new { |location| (location.address_changed? or location.city_changed? or location.state_changed? or location.zipcode_changed?) }
  # after_validation :reverse_geocode, :if => Proc.new { |location| (location.city.blank? or location.state.blank?) and (location.latitude_changed? or location.longitude_changed?) }  # TODO: reverse_geocode sets <address: "280 Broadway, Manhattan, NY 10007, USA">. this must be parsed into city, state, zip
  after_validation :set_time_zone, :if => Proc.new { |location| location.time_zone.blank? or location.latitude_changed? or location.longitude_changed? }


  #########################
  # Setup attributes (reader, accessible, protected)
  #########################
  #attr_reader
  #attr_accessor
  attr_accessible :name, :address, :city, :state, :zipcode


  #########################
  # Associations
  #########################
  belongs_to :user


  #########################
  # Validations
  #########################
  validates :name, :presence => true
  validates :city, :presence => true, :if => Proc.new { |location| location.latitude.blank? or location.longitude.blank? }
  validates :state, :presence => true, :if => Proc.new { |location| location.latitude.blank? or location.longitude.blank? }


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

  def full_street_address
    "#{self.address} #{self.city} #{self.state} #{self.zipcode}"
  end

  def map_url
    "http://maps.google.com/maps?q=#{self.address},+#{self.city},+#{self.state},+#{self.zipcode}&hl=en"
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

  def set_time_zone   
    begin
      # TODO: move this to a config file
      client = AskGeo.new(:account_id => '424004', :api_key => 'jstmdfns3e95odjv56hrgg79ak')

      response = client.lookup("#{self.latitude}, #{self.longitude}")
      tz = response["timeZone"]
      self.update_attribute("time_zone", tz)
    rescue AskGeo::APIError => e
      # Default to EST/EDT
      self.update_attribute("time_zone", "America/New_York")
    end
  end

end
