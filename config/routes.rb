Rails.application.routes.draw do
  # API endpoints
  post "/graphql", to: "graphql#execute"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :attachments, only: [ :create, :destroy ]
  get "/export/closed_tickets", to: "exports#closed_tickets"

  # Development tools
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  # Health check endpoint (for Render monitoring)
  get "up" => "rails/health#show", as: :rails_health_check

  root to: redirect("https://isaac.com")
end
