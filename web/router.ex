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

  pipeline :authenticate_admin do
    plug MelodicaInventory.Plugs.Authenticate, :admin
  end

  scope "/", MelodicaInventory do
    pipe_through [:browser, :authenticate]

    get "/", PageController, :index
    resources "/categories", CategoryController, only: [:show]

    resources "/items", ItemController, only: [:show]
    resources "/items/loans/:item_id", LoanController, only: [:new, :create]

    resources "/loans", LoanController, only: [:index]
  end

  scope "/admin", as: :admin, alias: MelodicaInventory.Admin do
    pipe_through [:browser, :authenticate_admin]

    resources "/items", ItemController, only: [:edit, :update]
    resources "/loans", LoanController, only: [:index]
    resources "/loan_returns/:loan_id", LoanReturnsController, only: [:create]
  end

  scope "/auth", MelodicaInventory do
    pipe_through :browser

    get "/", AuthController, :index, as: :login
    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", MelodicaInventory do
  #   pipe_through :api
  # end
end
