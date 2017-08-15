defmodule MelodicaInventoryWeb.ItemController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Loans.{Loan, ItemReservation}
  alias MelodicaInventory.Goods.{Item, Variation, Image, ImageOperations}

  alias Ecto.{Multi, Changeset}

  def show(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    |> Repo.preload([:attachments, :images, :loans, :variation])

    loans = (from l in Loan, where: l.item_id == ^id and not l.fulfilled)
    |> Repo.all
    |> Repo.preload([:item, :user])

    item_reservations = (from r in ItemReservation, where: r.item_id == ^id)
    |> Repo.all
    |> Repo.preload([event: :user])

    changeset = ItemReservation.changeset(%ItemReservation{item_id: id, quantity: item.quantity}, %{})

    render conn, "show.html", item: item, loans: loans, item_reservations: item_reservations, changeset: changeset
  end

  def new(conn, %{"variation_id" => variation_id}) do
    variation = Repo.get(Variation, variation_id)
    changeset = Item.changeset(%Item{variation_id: variation_id}, %{})

    render(conn, "new.html", variation: variation, changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    variation = Repo.get(Variation, item_params["variation_id"])
    changeset = Item.changeset(%Item{}, item_params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        ImageOperations.upload_images(item.id, item_params["image"])
        redirect(conn, to: item_path(conn, :show, item.id))
      {:error, changeset} ->
         render(conn, "new.html", variation: variation, changeset: changeset)
    end
  end
end
