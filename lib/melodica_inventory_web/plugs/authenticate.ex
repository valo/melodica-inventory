defmodule MelodicaInventoryWeb.Plugs.Authenticate do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller
  alias MelodicaInventoryWeb.Router.Helpers, as: RouterHelpers

  def init(default), do: default

  def call(%Plug.Conn{assigns: %{current_user: current_user}} = conn, :admin) do
    case current_user && current_user.admin do
      true ->
        conn
      _ ->
        conn
        |> put_flash(:info, "Access denied!")
        |> configure_session(drop: true)
        |> redirect(to: RouterHelpers.login_path(conn, :index))
        |> halt
    end
  end

  def call(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _default) do
    case current_user do
      nil ->
        conn
        |> redirect(to: RouterHelpers.login_path(conn, :index))
        |> halt
      _ ->
        conn
    end
  end
end
