Bikelog::Application.routes.draw do
  root :to => "dashboard#index", :as => :dashboard

  match "login" => "auth#login", :as => :login
  put "logout" => "auth#logout", :as => :logout

  get "profile" => "profile#index", :as => :profile
  put "profile" => "profile#update", :as => :update_profile

  get "dashboard/activity_plots_data" => "dashboard#activity_plots_data"

  resources :logs do
    collection do
      get "year/:year" => :index, :as => :year
    end

    member do
      get :tracks
      post :upload_track
      get :plot_data
    end

    resources :tracks do
      resources :trackpoints

      member do
        put "split/:trackpoint_id" => :split, :as => :split
        get :plot_data
      end
    end
  end
end
