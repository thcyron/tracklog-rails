Bikelog::Application.routes.draw do
  root :to => "dashboard#index", :as => :dashboard

  resources :logs do
    member do
      get :tracks
      post :upload_track
    end

    resources :tracks do
      resources :trackpoints

      member do
        put "split/:trackpoint_id" => :split, :as => :split
      end
    end
  end
end
