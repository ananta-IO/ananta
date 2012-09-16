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
end
