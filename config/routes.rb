# frozen_string_literal: true

Rails.application.routes.draw do
  mount Reader::API => '/'

  get '/', to: 'books#index', as: 'books'
  get '/book/:slug/:p', to: 'books#show', as: 'book'
  get '/book/:slug', to: 'books#show'
  get '/resume', to: 'books#resume', as: 'resume_book'

  get '/lookup/:q', to: 'lookups#new', as: 'lookup'

  get '/whoareyou', to: 'authentications#new', as: 'sign_in'
  post '/whoareyou', to: 'authentications#create'

  %w[422 500 503].each do |code|
    get code, to: 'errors#show', code: code
  end
  get '404', to: redirect('/whoareyou')
end
