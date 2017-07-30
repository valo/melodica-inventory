defmodule MelodicaInventoryWeb.ItemView do
  use MelodicaInventoryWeb, :view
  alias MelodicaInventory.Goods.Item
  import MelodicaInventoryWeb.ItemReservationView, only: [event_name: 1]
  import MelodicaInventoryWeb.EventView, only: [event_user: 1]

  def cover_url(%Item{images: [], attachments: []}) do
    nil
  end

  def cover_url(%Item{images: [], attachments: attachments}) do
    List.first(attachments).url
  end

  def cover_url(%Item{images: images}) do
    Cloudex.Url.for(hd(images).public_id, %{width: 600, height: 600, crop: "limit"})
  end
end
