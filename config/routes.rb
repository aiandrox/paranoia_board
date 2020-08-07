Rails.application.routes.draw do
  root 'static_pages#top'
  resources :comments, only: %i[create update destroy]
  resource :mypage, only: %i[show update]
end
