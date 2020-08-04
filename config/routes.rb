Rails.application.routes.draw do
  root 'static_pages#top'
  resources :comments, only: %i[create update destroy]
end
