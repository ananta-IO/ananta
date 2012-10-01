class Notification < ActiveRecord::Base

	state_machine :initial => :unviewed do
		event :view do
			transition :unviewed => :viewed
		end

		event :visit do
			transition [:unviewed, :viewed] => :visited
		end
	end

	attr_accessible :user, :notifiable, :message, :url, :on => :create
	attr_accessible :state_event

	belongs_to :user
	belongs_to :notifiable, :polymorphic => true

	validates :user_id, presence: true
	validates :notifiable_id, presence: true
	validates :notifiable_type, presence: true
	validates :message, presence: true

	scope :unviewed, where(:state => 'unviewed')
	scope :viewed, where(:state => 'viewed')
	scope :visited, where(:state => 'visited')
end
