defmodule MelodicaInventory.Goods.ItemDestroy do
  @moduledoc false

  alias MelodicaInventory.Goods.ImageOperations
  alias Ecto.Multi

  def build_item_destroy(item) do
    Multi.new()
    |> Multi.run(:delete_images, fn _repo, _ ->
      ImageOperations.delete_images_from_cloudex(item.images)
    end)
    |> Multi.delete(:delete_item, item)
  end
end
