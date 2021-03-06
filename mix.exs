defmodule MelodicaInventory.Mixfile do
  use Mix.Project

  def project do
    [
      app: :melodica_inventory,
      version: "0.0.1",
      elixir: "~> 1.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(Mix.env()),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MelodicaInventory.Application, []},
      applications:
        [
          :phoenix,
          :phoenix_pubsub,
          :phoenix_html,
          :cowboy,
          :logger,
          :gettext,
          :phoenix_ecto,
          :postgrex,
          :ueberauth_google,
          :timex,
          :httpoison
        ] ++ applications(Mix.env())
    ]
  end

  def applications(:test) do
    []
  end

  def applications(:prod) do
    [:cloudex, :scout_apm]
  end

  def applications(_) do
    [:cloudex]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:ecto_sql, "~> 3.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11.0"},
      {:ueberauth_google, "~> 0.4"},
      {:ex_machina, "~> 2.3"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:timex, "~> 3.0"},
      {:cloudex, "~> 0.1.10"},
      {:scout_apm, "~> 0.0"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:jason, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases(:test) do
    [test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end

  defp aliases(_) do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.migrate": ["ecto.migrate", "ecto.dump"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
