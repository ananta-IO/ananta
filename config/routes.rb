Ananta::Application.routes.draw do

	post "versions/:id/revert" => "versions#revert", :as => "revert_version"
	
	resources :sessions, :only => [:index]

	resources :comments, :only => [:index, :create, :update]

	resources :questions, :only => [:index, :show, :create, :update] do
		get 'page/:page', :action => :index, :on => :collection
		resources :answers, :only => [:index, :show, :create, :update] do
			resources :comments, :only => [:create]
		end
	end

	resources :images, :only => [:create, :update, :destroy]

	match '/login' => 'users#login', :via => :post # ujs re-render user_nav
	resources :users, :only => [:index]
	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations", :sessions => "users/sessions" }
	devise_scope :user do
		get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
		get '/login' => 'devise/sessions#new'
		get '/logout' => 'devise/sessions#destroy'
		get '/register' => 'devise/registrations#new'
	end

	match '/tb' => 'pages#tb' if Rails.env == 'development'
	match '/about' => 'pages#about'

	root :to => 'pages#home'

	resources :projects, :only => [:index] do
		get 'page/:page', :action => :index, :on => :collection
	end
	resources :profiles, :path => ''
	resources :users, :path => '', :only => [] do
		resources :projects, :path => '', :except => [:index]
	end

	# See how all your routes lay out with "rake routes"
end
