Bloccit::Application.routes.draw do


  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  #This declaration instructs the redirect to look for a controller in the users/ directory, by the name of omniauth_callbacks_controller.rb

  resources :users, only: [:show, :index] # create a route for users#show (this allows people to create a Public Profile)

  resources :topics do
    resources :posts, except: [:index], controller: 'topics/posts' do

      #By calling resources :posts in the resources :topics block, you are instructing Rails to create nested routes.
      #Posts should have a URL that is scoped to a topic. In other words, we want the app to respond to a request like: /topics/1/posts/3

      resources :comments, only: [:create, :destroy]   ##the resources command generates a bunch of routes, so the only: [:create] tells it to only make one for the create action
      match '/up-vote', to: 'votes#up_vote', as: :up_vote
      match '/down-vote', to: 'votes#down_vote', as: :down_vote

      #Notice that the match declarations are nested under :topics and :posts.

      resources :favorites, only: [:create, :destroy]
    end
  end

  match "about" => 'welcome#about', via: :get

  root :to => 'welcome#index'    #The root method allows you to declare the default page when a user types the home page URL
end