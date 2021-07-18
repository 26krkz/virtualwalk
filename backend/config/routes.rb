Rails.application.routes.draw do
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'

  get    '/favorite', to: 'favorites#show'
  post   '/favorite', to: 'favorites#create'
  delete '/favorite', to: 'favorites#destroy'

  resources :users do
    get :favorites, on: :collection
    get :guest, on: :collection
  end
  resources :videos
  resources :memos
end
