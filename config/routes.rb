Rails.application.routes.draw do
  mount Reader::API => '/'

  get '/book/:slug/:p', to: 'books#show', as: 'book'
  get '/book/:slug', to: 'books#show'
  
  get '/lookup/:q', to: 'lookups#new', as: 'lookup'
end
