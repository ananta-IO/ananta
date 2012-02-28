Ananta::Application.routes.draw do

	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
	devise_scope :user do
		get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
		get '/login' => 'devise/sessions#new'
		get '/logout' => 'devise/sessions#destroy'
	end

	# TODO: remove before golive
	match '/tb' => 'pages#tb'

	root :to => 'pages#home'

	resources :profiles, :path => ''
	resources :users, :path => '', :only => [] do
		resources :projects, :path => '', :except => [:index]
	end

	# See how all your routes lay out with "rake routes"
end
