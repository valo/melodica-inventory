defmodule MelodicaInventory.ItemDestroyTest do
  use MelodicaInventory.ModelCase

  import Mock

  alias MelodicaInventory.ItemDestroy
  alias MelodicaInventory.Item
  import MelodicaInventory.Factory

  test "deleting item without images" do
    item = insert(:item)
    |> Repo.preload([:attachments, :images])

    item_destroy = ItemDestroy.build_item_destroy(item)

    {:ok, _} = Repo.transaction(item_destroy)

    assert Repo.get(Item, item.id) == nil
  end

  test "deleting item with images" do
    image = insert(:image)
    item = Repo.get(Item, image.item_id)
    |> Repo.preload([:attachments, :images])

    item_destroy = ItemDestroy.build_item_destroy(item)

    with_mock Cloudex, [], [delete: fn _ -> [ok: true] end] do
      {:ok, _} = Repo.transaction(item_destroy)

      assert called Cloudex.delete([image.public_id])
    end

    assert Repo.get(Item, item.id) == nil
  end
end
