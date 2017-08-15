defmodule MelodicaInventory.Goods.ItemOperationsTest do
  @moduledoc false

  use MelodicaInventory.ModelCase

  import Mock

  alias MelodicaInventory.Goods.{Item, ImageOperations}
  import MelodicaInventory.Factory

  test "upload images" do
    item = insert(:item)

    with_mock Cloudex, [], [upload: fn _ -> [ok: %Cloudex.UploadedImage{public_id: "12345"}] end] do
      ImageOperations.upload_images(%{item: item}, [%Plug.Upload{path: "test.png"}])
    end

    updated_item = Repo.get(Item, item.id) |> Repo.preload([:attachments, :images])
    assert List.first(updated_item.images).public_id == "12345"
  end

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
