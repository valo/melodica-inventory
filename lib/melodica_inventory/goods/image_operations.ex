defmodule MelodicaInventory.Goods.ImageOperations do
  @moduledoc false

  import Ecto.Query

  alias MelodicaInventory.Goods.Image

  def delete_images(images) do
    if delete_by_public_id(images) == length(images) do
      Image |> where([i], i.public_id in ^images) |> Repo.delete_all
    end
  end

  defp delete_by_public_id(images) do
    Cloudex.delete(images)
    |> Enum.reduce(0, fn({:ok, _}, acc) -> 1 + acc end)
  end
end
