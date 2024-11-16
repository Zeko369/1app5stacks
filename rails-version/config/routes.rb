Rails.application.routes.draw do
  resources :pokemons, only: [] do
    get 'results', on: :collection
  end

  root 'home#index'
  post 'vote', to: 'home#vote'

  resources :faster, only: [:index, :create]

  # Keep any existing routes below this line
end
