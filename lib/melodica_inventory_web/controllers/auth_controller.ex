defmodule MelodicaInventoryWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use MelodicaInventoryWeb, :controller
  plug Ueberauth

  alias MelodicaInventory.Accounts.UserAuth

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: login_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome, #{ user.first_name } #{ user.last_name }")
        |> put_session(:current_user, user.id)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
