Bikelog::Application.routes.draw do
  root :to => "dashboard#index", :as => :dashboard

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
