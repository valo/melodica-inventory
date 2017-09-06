# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :melodica_inventory,
  ecto_repos: [MelodicaInventory.Repo]

# Configures the endpoint
config :melodica_inventory, MelodicaInventoryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TA7wdGLsJXMHMZY3Z+Q6LWGog1jhQbPastd5DlSaDq+LQuhDS6xTKZG5W84Vsbtq",
  render_errors: [view: MelodicaInventoryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MelodicaInventory.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]},
    facebook: {Ueberauth.Strategy.Facebook, [default_scope: "email,public_profile"]}
  ]

config :melodica_inventory, :trello_url, "https://api.trello.com/1"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
