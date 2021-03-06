Komanda::Application.routes.draw do
  root :to => 'parties#index'
  
  match '/stats' => 'static_pages#stats'
  match '/contact' => 'static_pages#contact'
  match '/signin' => 'static_pages#signin'
  
  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'parties#index'
  match '/signout' => 'sessions#destroy', :as => :signout
  
  match '/parties/rate', :controller => 'parties', :action => 'rate'
  match '/parties/join', :controller => 'parties', :action => 'join'
  match '/parties/unjoin', :controller => 'parties', :action => 'unjoin'

  match '/suggestions/star', :controller => 'suggestions', :action => 'star'
  match '/suggestions/unstar', :controller => 'suggestions', :action => 'unstar'
  
  resources :shares
  match '/shares' => 'shares#index'
  
  resources :comments
  resources :orders

  resources :parties do
    resources :comments
  end
  
  resources :suggestions do
    resources :comments
  end
end
