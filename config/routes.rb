Kickmeup::Application.routes.draw do
  resources :users, only: [:show] do
    member do
      get 'select_friends'
      post 'send_invites'
    end
  end

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
