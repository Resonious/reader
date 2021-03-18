Rails.application.routes.draw do
  mount Reader::API => '/'
end
