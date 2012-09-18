module ApplicationHelper
	include Twitter::Extractor

	def tb_alert_name name
		tb_names = {'notice' => 'success'}
		tb_names[name.to_s] || name.to_s
	end

	def hovercard model
		render "#{model.class.to_s.downcase.pluralize}/hovercard", model: model
	end

	def list_tags tags
		render "tags/tags", tags: tags
	end

	def markdown(text)
		text ||= '' # markdown barfs on nil
		raw $markdown.render(text)
	end

	def tagged_markdown(text)
		text ||= ''

		usernames = extract_mentioned_screen_names(text).uniq
		tags = extract_hashtags(text).uniq

		usernames.each_with_index { |u, i| text = text.gsub(/@#{u}/, "ausrname#{i}") }
		tags.each_with_index { |t, i| text = text.gsub(/##{t}/, "ahshtag#{i}") }

		text = markdown text

		usernames.each_with_index { |u, i| text = text.gsub(/ausrname#{i}/, "<a href='#{root_url}#{u}'>@#{u}</a>") }
		tags.each_with_index { |t, i| text = text.gsub(/ahshtag#{i}/, "<a href='#{root_url}tags/#{t}'>##{t}</a>") }

		raw text
	end

	def toggle_sort attribute, display_name, path, model_name
		if request.path != path
			session["#{model_name.downcase}_sort_attribute"] = nil
			session["#{model_name.downcase}_sort_direction"] = nil
		end

		current_sort_attribute = session["#{model_name.downcase}_sort_attribute"]
		current_sort_direction = session["#{model_name.downcase}_sort_direction"]

		if attribute != current_sort_attribute
			new_sort_direction = 'desc'
			arrow = " <i class='icon-sort'></i>"
		elsif current_sort_direction == 'asc'
			new_sort_direction = 'desc'
			arrow = " <i class='icon-sort-up'></i>"
		elsif current_sort_direction == 'desc'
			new_sort_direction = 'asc'
			arrow = " <i class='icon-sort-down'></i>"
		end

		query = "?sort=#{attribute}&direction=#{new_sort_direction}"

		raw "#{link_to display_name, path + query, remote: true}#{arrow}" 
	end
end
