Ananta::Application.routes.draw do
	
	resources :profiles do
		get :user
	end

	resources :projects

	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
	devise_scope :user do
		get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
		get '/login' => 'devise/sessions#new'
		get '/logout' => 'devise/sessions#destroy'
	end

	root :to => 'pages#home'

	# See how all your routes lay out with "rake routes"
end
