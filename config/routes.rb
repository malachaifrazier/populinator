Population::Application.routes.draw do
  
  get '/' => 'simulations#index'
  
  get '/people/random-name' => 'people#random_name'
  get '/settlements/random-name' => 'settlements#random_name'

  resources :events

  resources :settlements
  resources :damages
  resources :beings do
    resources :things
  end
  resources :things 
  resources :people, :controller => 'beings',  :type => 'Person'
  resources :rulers, :controller => 'beings',  :type => 'Ruler'
  
  post '/run'    => 'simulations#run'
  get  '/setup'  => 'simulations#setup'
  
end
