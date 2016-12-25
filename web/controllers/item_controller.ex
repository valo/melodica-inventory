defmodule MelodicaInventory.ItemController do
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
end
