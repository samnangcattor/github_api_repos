Rails.application.routes.draw do
  get "/oauth2callback", to: "tools#update"
  root "tools#index"

  resources :tools
end
