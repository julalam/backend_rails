Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only:[:index, :create, :update]
  resources :messages, only:[:index, :create]
  resources :languages, only:[:index]
  resources :countries, only:[:index]
  resources :contacts, only:[:index, :create, :update, :destroy]

  # custom routes
  post 'login', to: 'users#login'
  post 'logout', to: 'users#logout', as: 'logout'
  get 'search', to: 'users#search', as: 'search'

  mount ActionCable.server => '/cable'
end
