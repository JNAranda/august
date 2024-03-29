August::Application.routes.draw do
  get "static_pages/home"

  resources :users
  resources :sessions, :only=>[:new, :create,:destroy]
  
  match '/signup', :to=>('users#new')
  match '/signin', :to=> ('sessions#new')
  match '/signout', :to=> ('sessions#destroy'), :via=>:delete
end
