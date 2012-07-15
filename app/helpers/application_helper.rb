module ApplicationHelper
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
end
