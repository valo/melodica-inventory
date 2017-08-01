defmodule MelodicaInventory.VariationDestroy do
  @moduledoc false

  alias MelodicaInventory.ItemDestroy
  alias Ecto.Multi

  def build_destroy_action(variation) do
    Multi.new
    |> Multi.run(:delete_images, fn _ -> delete_images(variation.items) end)
    |> Multi.delete(:delete_variation, variation)
  end

  defp delete_images(items) do
    items
    |> Enum.flat_map(&(&1.images))
    |> ItemDestroy.delete_images()
  end
end
