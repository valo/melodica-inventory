defmodule MelodicaInventory.Web.Router do
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
    plug MelodicaInventory.Web.Plugs.Authenticate
  end

  pipeline :authenticate_admin do
    plug MelodicaInventory.Web.Plugs.Authenticate, :admin
  end

  pipeline :set_current_event do
    plug MelodicaInventory.Web.Plugs.SetCurrentEvent, :admin
  end

  scope "/", MelodicaInventory.Web do
    pipe_through [:browser, :authenticate, :set_current_event]

    get "/", CategoryController, :index
    resources "/categories", CategoryController, only: [:show]

    resources "/items", ItemController, only: [:show]
    resources "/items/loans/:item_id", LoanController, only: [:new, :create]

    resources "/loans", LoanController, only: [:index]

    resources "/item_reservations", ItemReservationController, only: [:new, :create, :delete]

    resources "/events", EventController, only: [:show]
    resources "/current_event", CurrentEventController, only: [:create]
  end

  scope "/admin", as: :admin, alias: MelodicaInventory.Web.Admin do
    pipe_through [:browser, :authenticate_admin]

    resources "/categories", CategoryController, only: [:edit, :update, :delete, :new, :create]
    resources "/items", ItemController, only: [:edit, :update]
    resources "/loans", LoanController, only: [:index]
    resources "/loan_returns/:loan_id", LoanReturnsController, only: [:create]
    resources "/events", EventController
  end

  scope "/auth", MelodicaInventory.Web do
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
