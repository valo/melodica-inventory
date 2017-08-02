defmodule MelodicaInventoryWeb.Plugs.Authenticate do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller
  alias MelodicaInventoryWeb.Router.Helpers, as: RouterHelpers

  def init(default), do: default

  def call(%Plug.Conn{assigns: %{current_user: current_user}} = conn, :admin) do
    case present?(current_user) and current_user.admin do
      false ->
        conn
        |> put_flash(:info, "Access denied!")
        |> configure_session(drop: true)
        |> redirect(to: RouterHelpers.login_path(conn, :index))
        |> halt
      true ->
        conn
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

  defp present?(nil), do: false
  defp present?(false), do: false
  defp present?(_), do: true
end
