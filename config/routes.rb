Rails.application.routes.draw do
  mount Reader::API => '/'

  resources :books, only: [:index, :show]
end
