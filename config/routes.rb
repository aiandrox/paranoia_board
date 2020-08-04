Rails.application.routes.draw do
  root to: 'static_pages#top'
  resources :comments, only: %i[create update destroy]
end
