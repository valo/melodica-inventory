use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :melodica_inventory, MelodicaInventory.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :melodica_inventory, MelodicaInventory.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "valentin",
  password: "",
  database: "melodica_inventory_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
