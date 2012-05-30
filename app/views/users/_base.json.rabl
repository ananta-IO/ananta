object @user

attributes :id, :username

node(:url) do |user|
	"#{root_url}#{user.username}" if user
end

node(:avatar) do |user|
	user.profile.avatar.image.small if user
end