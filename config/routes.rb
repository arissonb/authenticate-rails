Rails.application.routes.draw do
  post 'signup', to: 'users#create'
  post 'login', to: 'sessions#create'
  get 'foods', to: 'foods#index'
end
