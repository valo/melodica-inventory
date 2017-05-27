defmodule ItemDestroy do
  def build_item_destroy(item) do
    Ecto.Multi.new
    |> Ecto.Multi.run(:delete_images, fn _ -> delete_images(item.images) end)
    |> Ecto.Multi.delete(:delete_item, item)
  end

  def delete_images([]), do: {:ok, true}

  def delete_images(images) do
    images
    |> Enum.map(&(&1.public_id))
    |> Cloudex.delete()
    |> Enum.reduce(fn [ok: _], _ -> {:ok, true} end)
  end
end
