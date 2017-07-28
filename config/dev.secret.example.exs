use Mix.Config

config :cloudex,
  api_key: "CLOUDEX_API_KEY",
  secret: "CLOUDEX_SECRET",
  cloud_name: "CLOUDEX_CLOUD_NAME"

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "GOOGLE_CLIENT_ID",
  client_secret: "GOOGLE_CLIENT_SECRET"
