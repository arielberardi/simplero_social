Rails.application.routes.draw do
  resources :groups, except: %i[new edit] do
    resources :posts, only: %i[show create update destroy]
  end

  resources :posts do
    resources :comments, only: %i[create update destroy]
  end
end
