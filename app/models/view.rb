class View < ActiveRecord::Base
	
	#########################
	# Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
	#########################
	after_create :increment_viewable_view_count


	#########################
	# Setup attributes (reader, accessible, protected)
	#########################
	#attr_reader
	#attr_accessor
	attr_accessible :viewable, :viewable_id, :viewable_type, :user, :user_id, :ip


	#########################
	# Associations
	#########################
	belongs_to :viewable, polymorphic: true
	belongs_to :user


	#########################
	# Validations
	#########################
	validates :viewable_id, presence: true
	validates :viewable_type, presence: true
	validate :presence_of_ip_or_user
	validate :at_least_24hrs_between_views


	#########################
	# Scopes
	#########################
	scope :of, lambda { |viewable| where(viewable_id: viewable.id, viewable_type: viewable.class.to_s) } 
	scope :by, lambda { |user| where(user_id: user.id) } 
	scope :ip, lambda { |ip| where(ip: ip) } 


	#########################
	# Public Class Methods ( def self.method_name )
	#########################

	## (description is optional - try to make the name clear and method small so no description is needed)
	## One line description
	## maybe two
	#def self.my_method
	#
	#end


	#########################
	# Public Instance Methods ( def method_name )
	#########################

	## (description is optional - try to make the name clear and method small so no description is needed)
	#def my_method
	#
	#end


	#########################
	# Protected Methods
	#########################
protected

	# Same as Public Instance Methods


	#########################
	# Private Methods
	#########################
private
	def increment_viewable_view_count
		viewable.update_attribute(:view_count, viewable.view_count + 1)
	end
	
	def presence_of_ip_or_user
		errors.add(:ip, "must have an ip or a user_id") if ip.nil? and user_id.nil?
	end

	def at_least_24hrs_between_views
		if user and view = View.of(viewable).by(user).order('created_at DESC').first
			errors.add(:user_id, "cannot track view of the same thing more than once a day") if view.created_at + 1.day > DateTime.now.utc
		elsif ip and view = View.of(viewable).ip(ip).order('created_at DESC').first
			errors.add(:ip, "cannot track view of the same thing more than once a day") if view.created_at + 1.day > DateTime.now.utc
		end
	end


end
