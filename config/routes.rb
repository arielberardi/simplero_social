# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[sessions registrations]
  as :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    post 'sign_in', to: 'devise/sessions#create', as: :user_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session

    get 'sign_up', to: 'devise/registrations#new', as: :new_user_registration
    post 'sign_up', to: 'devise/registrations#create', as: :user_registration
  end

  resources :groups do
    resources :posts, except: %i[index new edit]
  end

  resources :posts, only: %i[] do
    resources :comments, only: %i[create update destroy]
  end

  root 'groups#index'
end
