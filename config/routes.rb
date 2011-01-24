Bikelog::Application.routes.draw do
  root :to => "dashboard#index", :as => :dashboard

  resources :logs do
    member do
      get :tracks
      post :upload_track
      get :distance_elevation_data
    end

    resources :tracks do
      resources :trackpoints

      member do
        put "split/:trackpoint_id" => :split, :as => :split
        get :distance_elevation_data
      end
    end
  end
end
