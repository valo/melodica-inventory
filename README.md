# Melodica Inventory System [![CircleCI](https://circleci.com/gh/valo/melodica-inventory.svg?style=svg&circle-token=b6d313d74859df4446c299443694f121ef37c5ba)](https://circleci.com/gh/valo/melodica-inventory)

To start the app:

  * Install dependencies with `mix deps.get`
  * Create and load your database with `mix ecto.create && mix ecto.load`
  * Install Node.js dependencies with `cd assets && yarn && cd ..`
  * Configure your development secrets `cp config/dev.secret.example.exs config/dev.secret.exs`. You can create a free account at [cloudinary](http://cloudinary.com/). Once you do that on your dashboard you'll have the credentials you have to fill in `dev.secret.exs`. Instructions for your OAuth setup can be found [here](https://developers.google.com/identity/sign-in/web/devconsole-project)
  * Start Phoenix endpoint with `mix phx.server`

  Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

  Running tests locally:
  * `mix test`

  Running linter locally:
  * `mix credo --strict`
