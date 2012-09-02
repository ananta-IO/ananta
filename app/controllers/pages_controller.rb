class PagesController < ApplicationController
	def show
	end

	def home
		@projects = Project.limit(5)
	end

	def robots
		if Rails.env.production?
			robots = File.read Rails.root.join('config', 'robots.txt')
			render :text => robots, :layout => false, :content_type => "text/plain"
		else
			render :text => "User-agent: *\nDisallow: /", :layout => false, :content_type => "text/plain"
		end
	end

	def me
		if current_user
			redirect_to current_user.profile	
		else
			redirect_to root_url
		end
	end
end