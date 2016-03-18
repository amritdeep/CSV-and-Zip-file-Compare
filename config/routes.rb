Rails.application.routes.draw do
  devise_for :users
  resources :batches do
    resources :records
  end

  root 'batches#index'
end
