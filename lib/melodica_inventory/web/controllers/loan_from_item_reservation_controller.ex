defmodule MelodicaInventory.Web.LoanFromItemReservationController do
  @moduledoc false
  use MelodicaInventory.Web, :controller

  alias MelodicaInventory.{ItemReservation, CreateLoan}

  def create(%Plug.Conn{assigns: %{current_user: current_user}} = conn, %{"item_reservation_id" => item_reservation_id}) do
    reservation =
      ItemReservation
      |> Repo.get(item_reservation_id)
      |> Repo.preload(:item)

    reservation
    |> CreateLoan.build_from_reservation(current_user)
    |> Repo.transaction
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Borrowed #{ reservation.quantity } #{ reservation.item.name }")
        |> redirect(to: event_path(conn, :show, reservation.event_id))
      _ ->
        conn
        |> put_flash(:error, "Can't borrow #{ reservation.quantity } #{ reservation.item.name }")
        |> redirect(to: event_path(conn, :show, reservation.event_id))
    end
  end
end
