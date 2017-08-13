defmodule MelodicaInventoryWeb.Admin.ItemView do
  use MelodicaInventoryWeb, :view

  alias MelodicaInventory.Goods.Item
  alias Cloudex.Url

  def cover_url(%Item{images: []}) do
    []
  end

  def cover_url(%Item{images: images}) do
    Enum.map(images, fn(image)  ->
      {Url.for(image.public_id, %{width: 400, height: 300, crop: "limit"}), image.public_id}
    end)
  end
end
