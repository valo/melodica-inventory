defmodule MelodicaInventoryWeb.Admin.ItemController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Goods.{Item, ItemOperations}

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

  def delete(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    |> Repo.preload([:attachments, :images, :variation])

    ItemOperations.destroy_item(item)
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
