defmodule MelodicaInventory.Goods.ItemDestroyTest do
  use MelodicaInventory.ModelCase

  alias MelodicaInventory.Goods.ItemDestroy
  alias MelodicaInventory.Goods.Item
  import MelodicaInventory.Factory

  test "deleting item without images" do
    item =
      insert(:item)
      |> Repo.preload([:attachments, :images])

    item_destroy = ItemDestroy.build_item_destroy(item)

    {:ok, _} = Repo.transaction(item_destroy)

    assert Repo.get(Item, item.id) == nil
  end
end
