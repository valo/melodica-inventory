defmodule MelodicaInventory.Web.ItemReservationController do
  use MelodicaInventory.Web, :controller

  alias MelodicaInventory.ItemReservation
  alias MelodicaInventory.Item
  alias MelodicaInventory.Event

  def new(conn, %{"item_id" => item_id}) do
    item = Repo.get!(Item, item_id)
    |> Repo.preload(:variation)
    events = Repo.all(Event)

    changeset = ItemReservation.changeset(%ItemReservation{item_id: item_id, quantity: item.quantity}, %{})

    render conn, "new.html", changeset: changeset, item: item, events: events
  end

  def create(conn, %{"item_reservation" => item_reservation_params}) do
    changeset = ItemReservation.changeset(%ItemReservation{}, item_reservation_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Reservation created successfully.")
        |> redirect(to: category_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item_reservation = Repo.get!(ItemReservation, id)

    Repo.delete(item_reservation)

    redirect(conn, to: event_path(conn, :show, item_reservation.event_id))
  end
end
