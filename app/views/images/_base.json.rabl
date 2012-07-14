object @image

attributes :id, :name, :imageable_id, :imageable_type, :user_id

node :size do |image|
	image.image.size
end

node :url do |image|
	image.image.url
end

node :small_url do |image|
	image.image.small.url
end

node :medium_url do |image|
	image.image.medium.url
end

node :large_url do |image|
	image.image.large.url
end