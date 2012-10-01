class ProjectMembership < ActiveRecord::Base

	include Rails.application.routes.url_helpers

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
		self.user.notifications.create(notifiable: self.project, message: "Your request to join <b>#{self.project.name}</b> was <span class='color-yes'>accepted</span>", url: "#{user_project_path(self.project.user, self.project)}#project-members")
	end

	def after_reject
		self.user.notifications.create(notifiable: self.project, message: "Your request to join <b>#{self.project.name}</b> was <span class='color-no'>rejected</span>", url: "#{user_project_path(self.project.user, self.project)}#project-members")
		self.destroy
	end


protected
	def notify_project
		self.project.user.notifications.create(notifiable: self, message: "<b>#{self.user.username}</b> requested to join <b>#{self.project.name}</b>", url: "#{user_project_path(self.project.user, self.project)}#project-members")
	end

end
