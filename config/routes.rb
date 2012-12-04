Komanda::Application.routes.draw do
  root :to => 'parties#index'
  
  #match '/users' => 'static_pages#users'
  match '/stats' => 'static_pages#stats'

  match '/contact' => 'static_pages#contact'
  
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout
  
  match '/shares' => 'shares#index'

  match '/parties/rate', :controller => 'parties', :action => 'rate'
  match '/parties/join', :controller => 'parties', :action => 'join'
  match '/parties/unjoin', :controller => 'parties', :action => 'unjoin'

  match '/suggestions/star', :controller => 'suggestions', :action => 'star'
  match '/suggestions/unstar', :controller => 'suggestions', :action => 'unstar'

  resources :shares
  resources :comments

  resources :parties do
    resources :comments
  end
  
  resources :suggestions do
    resources :comments
  end
end
