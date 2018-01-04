Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only:[:index, :create]
  resources :messages, only:[:index, :create]
  resources :languages, only:[:index]

  # custom routes
  post 'login', to: 'users#login'
  post 'logout', to: 'users#logout', as: 'logout'

end
