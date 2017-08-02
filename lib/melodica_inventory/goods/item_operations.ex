defmodule MelodicaInventory.Goods.ItemOperations do
  alias MelodicaInventory.Goods.{Item, Image, ImageOperations}
  alias MelodicaInventory.Repo

  def destroy_item(item) do
    Ecto.Multi.new
    |> Ecto.Multi.run(:delete_images, fn _ -> ImageOperations.delete_from_cloudex(item.images) end)
    |> Ecto.Multi.delete(:delete_item, item)
  end

  def create_item(item_params) do
    Ecto.Multi.new
    |> Ecto.Multi.insert(:item, Item.changeset(%Item{}, item_params))
    |> Ecto.Multi.run(:image, fn state -> upload_image(state, item_params["image"]) end)
  end

  def update_item(item, item_params) do
    Ecto.Multi.new
    |> Ecto.Multi.update(:item, Item.changeset(%Item{}, item_params))
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
