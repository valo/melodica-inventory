defmodule MelodicaInventory.Web.ItemView do
  use MelodicaInventory.Web, :view
  alias MelodicaInventory.Item
  import MelodicaInventory.Web.ItemReservationView, only: [event_name: 1]

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
