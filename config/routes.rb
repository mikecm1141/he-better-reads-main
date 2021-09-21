Rails.application.routes.draw do
  namespace :api do
    resources :authors, only: [:create, :index, :show, :update]
    resources :books, only: [:create, :index, :show, :update] do
      scope module: :books do
        resources :reviews, only: [:create, :index]
      end
    end
    resources :users, only: [:create, :index, :show, :update]
  end
end
