Rails.application.routes.draw do
  get 'searchs/search'
  root 'home#top'
  get 'home/about'
  devise_for :users

  # get 'users/:id' => 'users#show'
  resources :users, only: [:show, :index, :edit, :update] do
    resources :follows, only: [:index]
    # get 'users/:user_id/follows' => 'users#follows'
    resources :followers, only: [:index]
 end

  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]
end