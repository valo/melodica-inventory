defmodule MelodicaInventoryWeb.ItemController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.{Item, Variation, Image, Loan, ItemReservation}

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

    case Repo.transaction(add_new_item(item_params)) do
      {:ok, %{item: item}} ->
        redirect(conn, to: item_path(conn, :show, item.id))
      {:error, :item, failed_changeset, _changes_so_far} ->
        render(conn, "new.html", variation: variation, changeset: failed_changeset)
      {:error, :image, error, changes_so_far} ->
        changeset = changes_so_far[:item]
        |> Item.changeset
        |> Ecto.Changeset.add_error(:image, "cannot be uploaded! #{ error }")
        render(conn, "new.html", variation: variation, changeset: %{changeset | action: :insert})
    end
  end

  defp add_new_item(item_params) do
    Ecto.Multi.new
    |> Ecto.Multi.insert(:item, Item.changeset(%Item{}, item_params))
    |> Ecto.Multi.run(:image, fn state -> upload_image(state, item_params["image"]) end)
  end

  defp upload_image(%{item: %Item{}}, nil), do: {:error, "You need to upload an image"}

  defp upload_image(%{item: %Item{id: item_id}}, %Plug.Upload{path: filename}) do
    case Cloudex.upload(filename) do
      [error: error] ->
        {:error, inspect(error)}
      [ok: %Cloudex.UploadedImage{public_id: public_id}] ->
        {:ok, Repo.insert(%Image{public_id: public_id, item_id: item_id})}
    end
  end
end
