defmodule MelodicaInventory.Goods.ImageOperations do
  @moduledoc false

  import Ecto.Query

  alias MelodicaInventory.Goods.{Item, Image}
  alias MelodicaInventory.Repo

  def upload_images(item_id, nil) do
    {:ok, []}
  end

  def upload_images(item_id, uploaded_files) do
    uploaded_files
    |> Enum.each(&upload_to_cloudex_and_save(&1, item_id))

    {:ok, []}
  end

  def delete_images_from_cloudex([]), do: {:ok, true}

  def delete_images_from_cloudex(images) do
    images
    |> Enum.map(&(&1.public_id))
    |> Cloudex.delete()
    |> Enum.reduce(fn ({:ok, _}), _ -> {:ok, true} end)
  end

  def delete_images(images) do
    images
    |> Enum.each(fn(image) ->
      case Cloudex.delete(image) do
        {:ok, _} -> delete_image_from_db(image)
      end
    end)
  end

  defp delete_image_from_db(public_id) do
    Image |> where([i], i.public_id == ^public_id) |> Repo.delete_all
  end

  defp upload_to_cloudex_and_save(%Plug.Upload{path: filename}, item_id) do
    case Cloudex.upload(filename) do
      [error: _] ->
        {:ok, true}
      [ok: %Cloudex.UploadedImage{public_id: public_id}] ->
        {:ok, Repo.insert(%Image{public_id: public_id, item_id: item_id})}
    end
  end
end
