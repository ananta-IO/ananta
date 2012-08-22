# A physical location
#
class Location < ActiveRecord::Base
	
	#########################
	# Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
	#########################
	serialize :data
	
	geocoded_by :geocode_address, :latitude => :lat, :longitude => :lng
	reverse_geocoded_by :lat, :lng do |obj,results|
		if geo = results.first
			obj.address = geo.address
			# obj.data.city    = geo.city
			# obj.data.state   = geo.state
			# obj.data.zipcode = geo.postal_code
			# obj.data.country = geo.country_code
		end
	end

	# Versioning
	has_paper_trail

	after_validation :geocode, :if => Proc.new { |location| (location.address.blank? and location.ip) }
	# after_validation :set_timezone, :if => Proc.new { |location| (location.timezone.blank? or location.lat_changed? or location.lng_changed?) }
	before_save :reverse_geocode, :if => Proc.new { |location| (location.address.blank? and location.ip) }
	after_save :sync_locatable, :if => Proc.new { |location| location.locatable and (location.lat_changed? or location.lng_changed? or location.timezone_changed?) }


	#########################
	# Setup attributes (reader, accessible, protected)
	#########################
	attr_accessor :ip
	attr_accessible :name, :address, :lat, :lng, :data, :locatable, :locatable_id, :locatable_type


	#########################
	# Associations
	#########################
	belongs_to :locatable, :polymorphic => true


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


	#########################
	# Public Instance Methods ( def method_name )
	#########################

	def geocode_address
		self.ip || self.address
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
		obj.save!
	end

end
