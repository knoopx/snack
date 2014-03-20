Snack::Application.routes.draw do
  resources :entries

  resources :feeds do
    resources :entries
  end

  root to: "application#index"
end
