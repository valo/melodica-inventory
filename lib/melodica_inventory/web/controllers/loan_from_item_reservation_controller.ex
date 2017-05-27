defmodule MelodicaInventory.Web.LoanFromItemReservationController do
  use MelodicaInventory.Web, :controller

  alias MelodicaInventory.ItemReservation
  alias MelodicaInventory.CreateLoan

  def create(%Plug.Conn{assigns: %{current_user: current_user}} = conn, %{"item_reservation_id" => item_reservation_id}) do
    reservation = Repo.get(ItemReservation, item_reservation_id)
    |> Repo.preload(:item)

    Ecto.Multi.new()
    |> Ecto.Multi.append(CreateLoan.build_loan(reservation.item, current_user, reservation.quantity))
    |> Ecto.Multi.delete(:delete_reservation, reservation)
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
