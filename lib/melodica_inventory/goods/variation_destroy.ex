defmodule MelodicaInventory.Goods.VariationDestroy do
  alias MelodicaInventory.Goods.ImageOperations

  def build_destroy_action(variation) do
    Ecto.Multi.new
    |> Ecto.Multi.run(:delete_images, fn _ -> delete_images(variation.items) end)
    |> Ecto.Multi.delete(:delete_variation, variation)
  end

  defp delete_images(items) do
    items
    |> Enum.flat_map(&(&1.images))
    |> ImageOperations.delete_from_cloudex()
  end
end
