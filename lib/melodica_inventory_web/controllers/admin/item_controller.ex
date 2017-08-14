defmodule MelodicaInventoryWeb.Admin.ItemController do
  use MelodicaInventoryWeb, :controller
  alias MelodicaInventory.Goods.{Item, ItemDestroy, Image, Variation, ImageOperations}

  alias Ecto.{Multi, Changeset}

  def delete_images(conn, %{"images" => images, "id" => id} = params) do
    ImageOperations.delete_images(images)
    redirect(conn, to: item_path(conn, :show, id))
  end

  def edit(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    |> Repo.preload([:variation, :images])

    changeset = item |> Item.changeset

    render conn, "edit.html", item: item, changeset: changeset
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Repo.get!(Item, id)
    |> Repo.preload([:variation, :images])

    case Repo.transaction(update_item(item, item_params)) do
      {:ok, %{item: item}} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: category_path(conn, :show, item.variation.category_id))
      {:error, :item, failed_changeset, _changes_so_far} ->
        render(conn, "edit.html", item: item, changeset: failed_changeset)
      {:error, :image, error, changes_so_far} ->
        changeset = changes_so_far[:item]
        |> Item.changeset
        |> Changeset.add_error(:image, "cannot be uploaded! #{ error }")
        render(conn, "edit.html", item: item, changeset: %{changeset | action: :update})
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

  defp update_item(item, item_params) do
    Multi.new()
    |> Multi.update(:item, Item.changeset(item, item_params))
    |> Multi.run(:image, fn state -> upload_images(state, item_params["image"]) end)
  end

  defp upload_images(%{item: %Item{}}, nil), do: {:ok, true}

  defp upload_images(%{item: %Item{id: item_id}}, uploaded_files) do
    Enum.map(uploaded_files, &upload_to_cloudex_and_save(&1, item_id))
    |> format_response
  end

  defp upload_to_cloudex_and_save(%Plug.Upload{path: filename}, item_id) do
    case Cloudex.upload(filename) do
      [error: error] ->
         :error
      [ok: %Cloudex.UploadedImage{public_id: public_id}] ->
        {:ok, Repo.insert(%Image{public_id: public_id, item_id: item_id})}
    end
  end

  defp format_response(upload_images) do
    if :error in upload_images do
      {:error, "Cannot save image!"}
    else
      {:ok, true}
    end
  end
end
