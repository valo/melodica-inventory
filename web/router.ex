defmodule MelodicaInventory.Router do
  use MelodicaInventory.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug MelodicaInventory.Plugs.Authenticate
  end

  scope "/", MelodicaInventory do
    pipe_through [:browser, :authenticate]

    get "/", PageController, :index
  end

  scope "/auth", MelodicaInventory do
    pipe_through :browser

    get "/", AuthController, :index, as: :login
    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", MelodicaInventory do
  #   pipe_through :api
  # end
end
