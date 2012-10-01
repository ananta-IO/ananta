class ProjectMembership < ActiveRecord::Base

	state_machine :initial => :pending do
		event :accept do
			transition :pending => :accepted
		end
		after_transition any => :accepted, :do => :after_accept

		event :reject do
			transition :pending => :rejected
		end
		after_transition any => :rejected, :do => :after_reject
	end

	after_create :notify_project

	attr_accessible :state_event

	belongs_to :user
	belongs_to :project
	has_one :comment
	has_many :notifications, :as => :notifiable, :dependent => :destroy

	validates :user_id, presence: true, uniqueness: { scope: :project_id }
	validates :project_id, presence: true

	def after_accept
		self.user.notifications.create(notifiable: self, message: "<b>#{self.project.user.username}</b> <span class='color-yes'>accepted</span> your request to join <b>#{self.project.name}</b>") # TODO: maybe specify the url on the project explicitly and then copy it here?
	end

	def after_reject
		self.user.notifications.create(notifiable: self, message: "<b>#{self.project.user.username}</b> <span class='color-no'>rejected</span> your request to join <b>#{self.project.name}</b>") # TODO: maybe specify the url on the project explicitly and then copy it here?
		self.destroy
	end


protected
	def notify_project
		self.project.user.notifications.create(notifiable: self, message: "<b>#{self.user.username}</b> requested to join <b>#{self.project.name}</b>") # TODO: maybe specify the url on the project explicitly and then copy it here?
	end

end
