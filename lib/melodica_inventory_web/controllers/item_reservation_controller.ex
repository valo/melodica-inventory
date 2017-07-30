defmodule MelodicaInventoryWeb.ItemReservationController do
  use MelodicaInventoryWeb, :controller

  alias MelodicaInventory.Goods.ItemReservation
  alias MelodicaInventory.Goods.Item
  alias MelodicaInventory.Goods.Event

  def new(conn, %{"item_id" => item_id}) do
    item = Repo.get!(Item, item_id)
    |> Repo.preload(:variation)
    events = Repo.all(Event)

    changeset = ItemReservation.changeset(%ItemReservation{item_id: item_id, quantity: item.quantity}, %{})

    render conn, "new.html", changeset: changeset, item: item, events: events
  end

  def create(%Plug.Conn{assigns: %{current_event: current_event}} = conn, %{"item_reservation" => item_reservation_params}) do
    changeset = ItemReservation.changeset(%ItemReservation{event_id: current_event.id}, item_reservation_params)

    item = Repo.get!(Item, item_reservation_params["item_id"])
    |> Repo.preload(:variation)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Reservation created successfully.")
        |> redirect(to: category_path(conn, :show, item.variation.category_id))
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
