Rails.application.routes.draw do
  devise_for :users
  as :user do
    post 'users/sign_up', to: 'devise/registrations#create'
  end

  resources :groups do
    resources :posts, except: %i[new edit]
  end

  resources :posts do
    resources :comments, only: %i[create update destroy]
  end

  root 'groups#index'
end
