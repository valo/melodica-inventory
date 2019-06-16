defmodule MelodicaInventory.Goods.VariationDestroyTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Goods.{Variation, Item, VariationDestroy}
  import MelodicaInventory.Factory

  test "deleting variaion without items" do
    variation =
      insert(:variation)
      |> Repo.preload([:items])

    variation_destroy = VariationDestroy.build_destroy_action(variation)

    {:ok, _} = Repo.transaction(variation_destroy)

    assert Repo.get(Variation, variation.id) == nil
  end
end
