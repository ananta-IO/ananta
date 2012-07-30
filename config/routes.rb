Ananta::Application.routes.draw do

	post 'versions/:id/revert' => 'versions#revert', :as => 'revert_version'
	
	resources :sessions, :only => [:index]

	resources :comments, :only => [:index, :show, :create, :update, :destroy]
	resources :locations, :only => [:create, :update]

	resources :questions, :only => [:index, :show, :create, :update] do
		get 'page/:page', :action => :index, :on => :collection
		resources :answers, :only => [:index, :show, :create, :update] do
			resources :comments, :only => [:create]
		end
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

	match '/tb' => 'pages#tb' if Rails.env == 'development'
	match '/about' => 'pages#about'
	match '/robots.txt' => 'pages#robots'

	# TODO: should this be the last route?
	root :to => 'pages#home'

	resources :projects, :only => [:index] do
		collection do
			get 'page/:page', :action => :index
			get 'random'
		end
	end
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
