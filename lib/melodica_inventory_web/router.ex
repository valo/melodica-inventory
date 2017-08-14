defmodule MelodicaInventoryWeb.Router do
  use MelodicaInventoryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MelodicaInventoryWeb.Plugs.SetCurrentUser
    plug MelodicaInventoryWeb.Plugs.SetCurrentEvent
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug MelodicaInventoryWeb.Plugs.Authenticate
  end

  pipeline :authenticate_admin do
    plug MelodicaInventoryWeb.Plugs.Authenticate, :admin
  end

  scope "/", MelodicaInventoryWeb do
    pipe_through [:browser, :authenticate]

    get "/", CategoryController, :index
    resources "/categories", CategoryController, only: [:show]

    resources "/items", ItemController, only: [:show, :new, :create]
    resources "/items/loans/:item_id", LoanController, only: [:new, :create]

    resources "/loans", LoanController, only: [:index]

    resources "/item_reservations", ItemReservationController, only: [:new, :create, :delete]
    resources "/loan_from_item_reservation/:item_reservation_id", LoanFromItemReservationController, only: [:create]

    resources "/events", EventController, only: [:new, :create, :show, :index]
    resources "/current_event", CurrentEventController, only: [:create]
    resources "/search", SearchController, only: [:index]
  end

  scope "/admin", as: :admin, alias: MelodicaInventoryWeb.Admin do
    pipe_through [:browser, :authenticate_admin]

    resources "/categories", CategoryController, only: [:edit, :update, :delete, :new, :create]
    resources "/variations", VariationController, only: [:edit, :update, :delete, :new, :create]
    resources "/items", ItemController, only: [:edit, :update, :delete]
    put "/items/:id/delete_images", ItemController, :delete_images
    resources "/loans", LoanController, only: [:index]
    resources "/loan_returns/:loan_id", LoanReturnController, only: [:create]
    resources "/events", EventController, only: [:edit, :update, :delete]
  end

  scope "/auth", MelodicaInventoryWeb do
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
