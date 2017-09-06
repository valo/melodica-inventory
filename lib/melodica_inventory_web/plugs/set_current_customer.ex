defmodule MelodicaInventoryWeb.Plugs.SetCurrentCustomer do
  @moduledoc false

  import Plug.Conn
  alias MelodicaInventory.Accounts.Customer
  alias MelodicaInventory.Repo

  def init(default), do: default

  def call(conn, _default) do
    case get_session(conn, :current_customer) do
      nil ->
        conn
        |> assign(:current_customer, nil)
      current_customer_id ->
        assign(conn, :current_customer, Repo.get!(Customer, current_customer_id))
    end
  end
end
