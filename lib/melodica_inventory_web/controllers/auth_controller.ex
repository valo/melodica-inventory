defmodule MelodicaInventoryWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use MelodicaInventoryWeb, :controller
  plug Ueberauth

  alias MelodicaInventory.Accounts.UserAuth
  alias MelodicaInventory.Accounts.CustomerAuth

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

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => "google"}) do
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

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => "facebook"}) do
    customer = CustomerAuth.find_or_create!(auth)

    conn
    |> put_session(:current_customer, customer.id)
    |> redirect(to: "/melodicagram")
  end
end
