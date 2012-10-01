# One or two line description of what the model represents
#
#
require File.join(Rails.root, 'lib/ananta/vote')

class Comment < ActiveRecord::Base

	#########################
	# Callbacks & Misc method calls (e.g. devise for, acts_as_whatever )
	#########################
	include Ananta::Vote
	include Twitter::Extractor
	include Rails.application.routes.url_helpers
	
	acts_as_voteable
	acts_as_ordered_taggable

	# Versioning
	has_paper_trail

	after_save :extract_mentions
	after_save :extract_tags
	after_create :notify_commentable


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
	has_many :notifications, :as => :notifiable, :dependent => :destroy


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

	def path
		case self.commentable_type
		when "Project"
			commentable_path = user_project_path(self.commentable.user, self.commentable)
		when "Answer"
			commentable_path = question_path(self.commentable.question)
		else
			commentable_path = nil
		end
		
		if commentable_path
			"#{commentable_url}#comment_#{self.id}"
		else
			nil
		end
	end


	#########################
	# Protected Methods
	#########################
protected

	def extract_mentions
		if comment_changed?
			old_usernames = extract_mentioned_screen_names(changes[:comment][0]).uniq
			new_usernames = extract_mentioned_screen_names(changes[:comment][1]).uniq
			added_usernames = new_usernames - old_usernames
			added_usernames.each do |username|
				if u = User.find_by_username(username)
					u.notifications.create(notifiable: self, message: "<b>#{self.user.username}</b> mentioned you in a comment", url: self.path) # TODO: maybe specify the url on the comment explicitly and then copy it here?
				end
			end
		end
	end

	def extract_tags
		if comment_changed?
			tags = extract_hashtags(self.comment).uniq
			self.tag_list = tags.reverse.join(',')
		end
	end

	def notify_commentable
		self.commentable.user.notifications.create(notifiable: self, message: "<b>#{self.user.username}</b> commented on your #{self.commentable_type.downcase}", url: self.path) # TODO: maybe specify the url on the comment explicitly and then copy it here?
	end


	#########################
	# Private Methods
	#########################
private

	# Same as Public Instance Methods


end