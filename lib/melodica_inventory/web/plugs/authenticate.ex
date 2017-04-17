defmodule MelodicaInventory.Web.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(%Plug.Conn{assigns: %{current_user: current_user}} = conn, :admin) do
    case current_user && current_user.admin do
      false ->
        conn
        |> redirect(to: "/auth/login")
        |> halt
      true ->
        conn
    end
  end

  def call(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _default) do
    case current_user do
      nil ->
        conn
        |> redirect(to: "/auth/login")
        |> halt
      _ ->
        conn
    end
  end
end
