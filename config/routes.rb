Rails.application.routes.draw do

  get 'search/basic_search'
  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy

  # Authentication routes


  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  resources :users, except: [:new, :edit]

  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  resources :sessions, except: [:new, :destroy]


  # Resource routes (maps HTTP verbs to controller actions automatically):
  resources :owners
  resources :animals
  resources :visits
  resources :dosages
  resources :treatments
  resources :medicines
  resources :procedures

# resources: creates all the routes for all the CRUD operations for pets automatically
  resources :pets
# It generates the following routes
# Prefix	 Verb   URI Pattern	        	    Controller#Action
# pets	   GET    /pets(.:format)	    	    pets#index
# 		     POST   /pets(.:format)	    	    pets#create
# new_pet  GET    /pets/new(.:format)		    pets#new
# edit_pet GET    /pets/:id/edit(.:format)	pets#edit
# pet 	   GET    /pets/:id(.:format)		    pets#show
#   		   PATCH  /pets/:id(.:format)		    pets#update
#   		   DELETE /pets/:id(.:format)	    	pets#destroy

  # OR you can generate them manually.
  # get '/pets', to: 'pets#index', as: :pet # as creates an alias.
  # get '/pets/:id', to: 'pets#show'
  # get '/pets/new', to: 'pets#new'
  # get '/pets/:id/edit', to: 'pets#edit'
  # post '/pets', to: 'pets#create'
  # patch '/pets/:id', to: 'pets#update'
  # delete '/pets/:id', to: 'pets#destroy'

  # Routes for mecidine and procedure costs
  get 'medicine_costs/new', to: 'medicine_costs#new', as: :new_medicine_cost
  get 'procedure_costs/new', to: 'procedure_costs#new', as: :new_procedure_cost

  post 'medicine_costs', to: 'medicine_costs#create'
  post 'procedure_costs', to: 'procedure_costs#create'

  # Search routes
  get 'search/', to: 'search#basic_search', as: :search

  # You can have the root of your site routed with 'root'
  root 'home#index'

  # Another possible custom route that points to a non RESTful action.
  # post 'medicine_cost_terminate', to: 'medicine_costs#terminate'
end
