defmodule MelodicaInventory.Goods.VariationDestroyTest do
  use MelodicaInventory.ModelCase

  import Mock

  alias MelodicaInventory.Goods.{Variation, Item, VariationDestroy}
  import MelodicaInventory.Factory

  test "deleting variaion without items" do
    variation = insert(:variation)
    |> Repo.preload([:items])

    variation_destroy = VariationDestroy.build_destroy_action(variation)

    {:ok, _} = Repo.transaction(variation_destroy)

    assert Repo.get(Variation, variation.id) == nil
  end

  test "deleting variation with items and images" do
    image = insert(:image)
    item = Repo.get!(Item, image.item_id)
    |> Repo.preload([:variation])

    _second_item = insert(:item, variation: item.variation)

    variation = Repo.get!(Variation, item.variation_id)
    |> Repo.preload(items: :images)

    variation_destroy = VariationDestroy.build_destroy_action(variation)

    with_mock Cloudex, [], [delete: fn _ -> [ok: true] end] do
      {:ok, _} = Repo.transaction(variation_destroy)

      assert Repo.get(Variation, variation.id) == nil

      assert called Cloudex.delete([image.public_id])
    end

    assert Repo.get(Item, item.id) == nil
  end
end
