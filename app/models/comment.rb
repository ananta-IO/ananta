# One or two line description of what the model represents
#
#
class Comment < ActiveRecord::Base

	#########################
	# Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
	#########################
	include Ananta::Vote
	include Twitter::Extractor
	
	acts_as_voteable
	acts_as_ordered_taggable

	# Versioning
	has_paper_trail

	before_save :extract_mentions
	before_save :extract_tags
	before_save :extract_tags


	#########################
	# Setup attributes (reader, accessible, protected)
	#########################
	#attr_reader
	#attr_accessor
	# Make sure all controllers that create comments define user_id = current_user.id
	attr_accessible :comment, :commentable_id, :commentable_type, :cast_vote, :on => :create


	#########################
	# Associations
	#########################
	belongs_to :user
	belongs_to :commentable, :polymorphic => true
	has_many :comments, :as => :commentable, :dependent => :destroy


	#########################
	# Validations
	#########################
	# validates :user_id, :presence => true
	# validates :commentable_id, :presence => true
	# validates :commentable_type, :presence => true
	validates :comment, :presence => true, :length => { :in => 1..65535 }


	#########################
	# Scopes
	#########################
	default_scope :order => 'created_at asc'

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

	def editors
		editors = [self.user]
		editors
	end


	#########################
	# Protected Methods
	#########################
protected

	def extract_mentions
		if comment_changed?
			old_usernames = extract_mentioned_screen_names(changes[:comment][0]).uniq
			new_usernames = extract_mentioned_screen_names(changes[:comment][1]).uniq
			
			puts ">>>>>>>> usernames"
			puts old_usernames.inspect
			puts new_usernames.inspect
			# TODO
		end
	end

	def extract_tags
		if comment_changed?
			tags = extract_hashtags(self.comment).uniq
			self.tag_list = tags.reverse.join(',')
		end
	end


	#########################
	# Private Methods
	#########################
private

	# Same as Public Instance Methods


end