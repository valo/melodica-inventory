defmodule MelodicaInventory.Web.Admin.ItemController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Item

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

    Ecto.Multi.new
    |> Ecto.Multi.run(:delete_images, fn _ -> delete_images(item.images) end)
    |> Ecto.Multi.delete(:delete_item, item)
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

  def delete_images(images) do
    images
    |> Enum.map(&(&1.public_id))
    |> Cloudex.delete()
    |> Enum.reduce(fn [ok: _], _ -> {:ok, true} end)
  end
end
