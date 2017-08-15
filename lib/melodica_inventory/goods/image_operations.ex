defmodule MelodicaInventory.Goods.ImageOperations do
  @moduledoc false

  import Ecto.Query

  alias MelodicaInventory.Goods.{Item, Image}
  alias MelodicaInventory.Repo

  def upload_images(item_state, images, opts \\ [])
  def upload_images(%{item: %Item{}}, nil, opts) do
    if opts[:required] do
      {:error, "You need to upload an image"}
    else
      {:ok, true}
    end
  end

  def upload_images(%{item: %Item{id: item_id}}, uploaded_files, opts) do
    Enum.map(uploaded_files, &upload_to_cloudex_and_save(&1, item_id))
    |> format_response
  end

  def delete_images(images) do
    if delete_by_public_id(images) == length(images) do
      Image |> where([i], i.public_id in ^images) |> Repo.delete_all
    end
  end

  defp delete_by_public_id(images) do
    Cloudex.delete(images)
    |> Enum.reduce(0, fn({:ok, _}, acc) -> 1 + acc end)
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
