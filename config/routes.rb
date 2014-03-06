Bloccit::Application.routes.draw do

  get "comments/create"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  #This declaration instructs the redirect to look for a controller in the users/ directory, by the name of omniauth_callbacks_controller.rb

  resources :users, only: [:show] # create a route for users#show

  resources :topics do
    resources :posts, except: [:index] do
      resources :comments, only: [:create, :destroy]   ##the resources command generates a bunch of routes, so the only: [:create] tells it to only make one for the create action
      match '/up-vote', to: 'votes#up_vote', as: :up_vote
      match '/down-vote', to: 'votes#down_vote', as: :down_vote
      resources :favorites, only: [:create, :destroy]
    end
  end

  match "about" => 'welcome#about', via: :get

  root :to => 'welcome#index'
end