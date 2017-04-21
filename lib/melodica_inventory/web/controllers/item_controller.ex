defmodule MelodicaInventory.Web.ItemController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Item
  alias MelodicaInventory.Loan
  alias MelodicaInventory.ItemReservation

  def show(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    |> Repo.preload(:attachments)

    loans = (from l in Loan, where: l.item_id == ^id and not l.fulfilled)
    |> Repo.all
    |> Repo.preload([:item, :user])

    item_reservations = (from r in ItemReservation, where: r.item_id == ^id)
    |> Repo.all
    |> Repo.preload([:event])

    changeset = ItemReservation.changeset(%ItemReservation{item_id: id, quantity: item.quantity}, %{})

    render conn, "show.html", item: item, loans: loans, item_reservations: item_reservations, changeset: changeset
  end
end
