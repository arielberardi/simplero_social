Rails.application.routes.draw do
  resources :groups do
    resources :posts, except: %i[new edit]
  end

  resources :posts do
    resources :comments, only: %i[create update destroy]
  end

  root 'groups#index'
end
