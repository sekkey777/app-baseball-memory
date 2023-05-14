Rails.application.routes.draw do
  get 'games/new'
  get 'games/index'
  get 'games/show'
  root to: 'posts#top'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users
  resources :posts do
    resources :likes, only: [:create, :destroy]
  end
  resources :my_posts
end
