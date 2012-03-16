Ananta::Application.routes.draw do

	resources :sessions, :only => [:index]

	resources :comments, :only => [:index, :create, :update]

	resources :questions, :only => [:index, :show, :create, :update] do
		get 'page/:page', :action => :index, :on => :collection
		resources :answers, :only => [:index, :show, :create, :update] do
			resources :comments, :only => [:create]
		end
	end

	resources :images, :only => [:create, :update, :destroy]

	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
	devise_scope :user do
		get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
		get '/login' => 'devise/sessions#new'
		get '/logout' => 'devise/sessions#destroy'
	end

	# TODO: remove before golive
	match '/tb' => 'pages#tb'

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
