class ProjectMembership < ActiveRecord::Base

	state_machine :initial => :pending do
		event :accept do
			transition :pending => :accepted
		end

		event :reject do
			transition :pending => :rejected
		end
		after_transition any => :rejected, :do => :after_reject
	end

	attr_accessible :state_event

	belongs_to :user
	belongs_to :project
	has_one :comment

	validates :user_id, presence: true, uniqueness: { scope: :project_id }
	validates :project_id, presence: true

	def after_reject
		self.destroy
	end
end
