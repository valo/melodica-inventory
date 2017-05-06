defmodule MelodicaInventory.Web.Admin.ItemController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.{Item, Variation, Image}

  def edit(conn, %{"id" => id}) do
    changeset = Repo.get!(Item, id, preload: [:variation])
    |> Repo.preload(:variation)
    |> Item.changeset

    render conn, "edit.html", changeset: changeset
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    changeset = Repo.get!(Item, id)
    |> Repo.preload(:variation)
    |> Item.changeset(item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: category_path(conn, :show, item.variation.category_id))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
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
        IO.inspect(failed_changeset)
        render(conn, "new.html", variation: variation, changeset: failed_changeset)
      {:error, :upload_image, error, changes_so_far} ->
        changeset = changes_so_far[:item]
        |> Item.changeset
        |> Ecto.Changeset.add_error(:image, "cannot be uploaded! #{ error }")
        render(conn, "new.html", variation: variation, changeset: %{changeset | action: :insert})
    end
  end

  defp add_new_item(item_params) do
    Ecto.Multi.new
    |> Ecto.Multi.insert(:item, Item.changeset(%Item{}, item_params))
    |> Ecto.Multi.run(:upload_image, fn _multi -> upload_image(item_params["image"]) end)
  end

  defp upload_image(image_upload) do
    {:error, "Cannot upload image"}
  end
end
