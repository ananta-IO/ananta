# A physical location
#
class Location < ActiveRecord::Base
	
	#########################
	# Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
	#########################
	serialize :data, ActiveRecord::Coders::Hstore
	
	geocoded_by :geocode_address
	# reverse_geocoded_by :lat, :lng do |obj,results|
	#	if geo = results.first
	#		obj.data.city    = geo.city
	#		obj.data.state   = geo.state
	#		obj.data.zipcode = geo.postal_code
	#		obj.data.country = geo.country_code
	#	end
	# end

	after_validation :geocode, :if => Proc.new { |location| (location.address.blank? and location.ip) }
	# after_validation :set_timezone, :if => Proc.new { |location| (location.timezone.blank? or location.lat_changed? or location.lng_changed?) }
	# before_save :reverse_geocode, :if => Proc.new { |location| (location.lat_changed? or location.lng_changed?) and !(location.street_changed? or location.city_changed? or location.state_changed? or location.zipcode_changed? or location.country_changed?) }
	after_save :sync_locatable, :if => Proc.new { |location| location.locatable and (location.lat_changed? or location.lng_changed? or location.timezone_changed?) }


	#########################
	# Setup attributes (reader, accessible, protected)
	#########################
	attr_accessor :ip
	attr_accessible :name, :address, :lat, :lng, :data


	#########################
	# Associations
	#########################
	belongs_to :locatable, :polymorphic => true


	#########################
	# Validations
	#########################
	validates :name, :presence => true
	# validates :address, :presence => true, :if => Proc.new { |location| location.ip.nil? and (location.lat.blank? or location.lng.blank?) }


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

	def geocode_address
		ip || address
	end

	def map_url
		"http://maps.google.com/maps?q=#{self.address}&hl=en"
	end


	#########################
	# Protected Methods
	#########################
	protected


	#########################
	# Private Methods
	#########################
	private

	# def set_timezone   
	#   begin
	#     # TODO: move this to a config file
	#     client = AskGeo.new(:account_id => '424004', :api_key => 'jstmdfns3e95odjv56hrgg79ak')

	#     response = client.lookup("#{self.lat}, #{self.lng}")
	#     tz = response["timeZone"]
	#     self.timezone = tz
	#   rescue AskGeo::APIError => e
	#     # Default to EST/EDT
	#     self.timezone = "America/New_York"
	#   end
	# end

	def sync_locatable
		obj = self.locatable
		%w(lat lng timezone).each do |a|
			obj[a.to_sym] = self[a.to_sym]
		end
		obj.save
	end

end
