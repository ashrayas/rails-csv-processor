Rails.application.routes.draw do

  root 'main#index'
  get '/main', to: 'main#index'
  get '/result', to: 'main#result'
  post '/result', to: 'main#result'
  post '/search', to: 'main#search'
  get '*unmatched_route', to: 'main#index'

end
