Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "simulator#show"
  get "simulator", to: "simulator#show", as: :simulator
  post "simulator/power", to: "simulator#power_toggle", as: :simulator_power
  post "simulator/load", to: "simulator#load", as: :simulator_load
  post "simulator/juice_batch", to: "simulator#juice_batch", as: :simulator_juice_batch
  post "simulator/empty_jug", to: "simulator#empty_jug", as: :simulator_empty_jug
  post "simulator/reset", to: "simulator#reset", as: :simulator_reset
  post "simulator/safety", to: "simulator#safety", as: :simulator_safety

  resources :products, only: %i[index show], path: "catalog"
end
