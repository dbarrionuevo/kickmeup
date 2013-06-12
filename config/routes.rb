Kickmeup::Application.routes.draw do
  resources :kicked_ideas
  resources :ideas do
    member do
      get 'kickup'
    end
  end

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'sessions/destroy', as: 'signout'

  root to: 'ideas#index'
end
