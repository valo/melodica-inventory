defmodule MelodicaInventory.Goods.ItemOperationsTest do
  @moduledoc false

  use MelodicaInventory.ModelCase

  import Mock

  alias MelodicaInventory.Goods.{Item, ImageOperations}
  import MelodicaInventory.Factory

  test "deleting images" do
    image = insert(:image)
    item = Repo.get(Item, image.item_id)
    |> Repo.preload([:attachments, :images])

    with_mock Cloudex, [], [delete: fn _ -> [{:ok,  %Cloudex.DeletedImage{public_id: image.public_id}}] end] do
      ImageOperations.delete_images([image.public_id])

      assert called Cloudex.delete([image.public_id])
    end

    updated_item = Repo.get(Item, item.id) |> Repo.preload([:attachments, :images])
    assert updated_item.images == []
  end
end
