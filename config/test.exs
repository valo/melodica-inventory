use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :melodica_inventory, MelodicaInventory.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :melodica_inventory, MelodicaInventory.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "ubuntu",
  password: "",
  database: "circle_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

if File.exists?("config/test.secret.exs") do
  import_config "test.secret.exs"
end
