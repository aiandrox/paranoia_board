Rails.application.routes.draw do
  root 'static_pages#top'
  resources :comments, only: %i[create update destroy]
  resource :mypage, only: %i[show update]
  namespace :mypage do
    resource :first_name, only: %i[update]
  end
end
