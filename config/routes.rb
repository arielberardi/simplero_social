Rails.application.routes.draw do
  resources :groups do
    resources :posts
  end

  resources :posts do
    resources :comments
  end
end
