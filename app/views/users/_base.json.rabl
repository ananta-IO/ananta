object @user

attributes :id, :username

node(:avatar) do |user|
	user.profile.avatar.image.small if user
end