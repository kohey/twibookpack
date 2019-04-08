Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: 'home#index'
  
  get 'home/index'
  get '/auth/:provider/callback', to: 'sessions#callback'
  post '/auth/:provider/callback', to: 'sessions#callback'
  get '/logout', to: 'sessions#destroy', as: :logout
  get '/home', to: 'toppages#timeline', as: :home
  post '/home/tweet', to: 'toppages#tweet', as: :tweet
  
  post '/home/analyze_10', to: 'toppages#analyze_10'
  post '/home/analyze_8', to: 'toppages#analyze_8'
  post '/home/analyze_5', to: 'toppages#analyze_5'

end
