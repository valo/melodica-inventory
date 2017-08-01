defmodule MelodicaInventoryWeb.Plugs.SetCurrentUser do
  import Plug.Conn
  alias MelodicaInventory.Accounts.User
  alias MelodicaInventory.Repo

  def init(default), do: default

  def call(conn, _default) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> assign(:current_user, nil)
      current_user_id ->
        assign(conn, :current_user, Repo.get!(User, current_user_id))
    end
  end
end
