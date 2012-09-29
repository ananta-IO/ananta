Ananta::Application.routes.draw do

	ActiveAdmin.routes(self)
	devise_for :admin_users, ActiveAdmin::Devise.config

	post 'versions/:id/revert' => 'versions#revert', :as => 'revert_version'
	
	resources :sessions, :only => [:index]

	resources :comments, :only => [:index, :show, :create, :edit, :update, :destroy]
	resources :locations, :only => [:create, :update]

	resources :questions, :only => [:index, :show, :create, :update] do
		collection do
			get 'page/:page', :action => :index
			get 'random_unanswered'
		end
		resources :answers, :only => [:index, :show, :create, :update] do
			resources :comments, :only => [:create]
		end
	end

	resources :projects, :only => [:index, :show] do
		collection do
			get 'page/:page', :action => :index
			get 'random'
		end
		resources :comments, :only => [:index]
	end

	resources :images, :only => [:create, :update, :destroy]

	match '/render_nav' => 'users#render_nav' # ujs render user_nav. generally called after ajax login
	resources :users, :only => [:index] do
		collection do
			get 'random'
		end
	end
	devise_for :users, :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks', :registrations => 'users/registrations', :sessions => 'users/sessions' }
	devise_scope :user do
		get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
		get '/login' => 'devise/sessions#new'
		get '/logout' => 'devise/sessions#destroy'
		get '/register' => 'devise/registrations#new'
	end

	match '/me' => 'pages#me' 
	match '/tb' => 'pages#tb' if Rails.env == 'development'
	match '/about' => 'pages#about'
	match '/robots.txt' => 'pages#robots'

	root :to => 'pages#home'

	resources :profiles, :path => '' do
		member do
			get :edit_location
		end
	end
	resources :users, :path => '', :only => [] do
		resources :projects, :path => '', :except => [:index]
	end

	# See how all your routes lay out with "rake routes"
end
