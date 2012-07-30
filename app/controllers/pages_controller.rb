class PagesController < ApplicationController
	def show
	end

	def robots
		if Rails.env.production?
			robots = File.read Rails.root.join('config', 'robots.txt')
			render :text => robots, :layout => false, :content_type => "text/plain"
		else
			render :text => "User-agent: *\nDisallow: /", :layout => false, :content_type => "text/plain"
		end
	end
end