defmodule MelodicaInventory.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller
  alias MelodicaInventory.User
  alias MelodicaInventory.Repo

  def init(default), do: default

  def call(conn, _) do
    assign(conn, :current_user, Repo.get_by!(User, admin: false))
  end

  def call(conn, :admin) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> redirect(to: "/auth/login")
        |> halt
      current_user_id ->
        current_user = Repo.get!(User, current_user_id)
        if current_user.admin do
          assign(conn, :current_user, current_user)
        else
          conn
          |> redirect(to: "/auth/login")
          |> halt
        end
    end
  end

  def call(conn, default) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> redirect(to: "/auth/login")
        |> halt
      current_user_id ->
        assign(conn, :current_user, Repo.get!(User, current_user_id))
    end
  end
end
