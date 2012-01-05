Bikelog::Application.routes.draw do
  root to: "dashboard#index", as: :dashboard

  match "login" => "auth#login", as: :login, via: [:get, :post]
  put "logout" => "auth#logout", as: :logout

  get "profile" => "profile#index",  as: :profile
  put "profile" => "profile#update", as: :update_profile

  get "dashboard/activity_plots_data" => "dashboard#activity_plots_data"

  get "admin" => "admin#index", as: :admin

  resources :logs do
    collection do
      get "year/:year" => :index, as: :year
    end

    member do
      get :tracks
    end

    resources :tracks do
      resources :trackpoints

      member do
        match :transfer, via: [:get, :post]
        put "split/:trackpoint_id" => :split, as: :split
      end
    end
  end

  namespace :admin do
    resources :users
  end
end
