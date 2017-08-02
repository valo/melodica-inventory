defmodule MelodicaInventory.Goods.ImageOperations do
  def delete_from_cloudex([]), do: {:ok, true}

  def delete_from_cloudex(images) do
    images
    |> Enum.map(&(&1.public_id))
    |> Cloudex.delete()
    |> Enum.reduce(fn [ok: _], _ -> {:ok, true} end)
  end
end
