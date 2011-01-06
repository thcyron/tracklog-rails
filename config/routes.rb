Bikelog::Application.routes.draw do
  root :to => "dashboard#index", :as => :dashboard

  resources :logs do
    member do
      get :tracks
      post :upload_track
    end

    resources :tracks do
      resources :trackpoints
    end
  end
end
