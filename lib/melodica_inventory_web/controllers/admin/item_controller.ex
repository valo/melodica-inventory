defmodule MelodicaInventoryWeb.Admin.ItemController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Goods.{Item, ItemDestroy, Image, Variation, ImageOperations}

  alias Ecto.{Multi, Changeset}

  def edit(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    |> Repo.preload([:variation, :images])

    changeset = item |> Item.changeset

    render conn, "edit.html", item: item, changeset: changeset
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Repo.get!(Item, id)
    |> Repo.preload([:variation, :images])

    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        ImageOperations.upload_images(item.id, item_params["image"])
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: category_path(conn, :show, item.variation.category_id))
      {:error, changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    |> Repo.preload([:attachments, :images, :variation])

    ItemDestroy.build_item_destroy(item)
    |> Repo.transaction
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "#{item.name} delete successfully")
        |> redirect(to: category_path(conn, :show, item.variation.category_id))
      {:error, _} ->
        conn
        |> put_flash(:error, "#{item.name} could not be deleted")
        |> redirect(to: category_path(conn, :show, item.variation.category_id))
    end
  end
end
