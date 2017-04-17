defmodule MelodicaInventory.Web.ItemView do
  use MelodicaInventory.Web, :view
  alias MelodicaInventory.Item
  import MelodicaInventory.Web.ItemReservationView, only: [event_name: 1]

  def cover_url(%Item{attachments: []}) do
    nil
  end

  def cover_url(%Item{attachments: attachments}) do
    List.first(attachments).url
  end
end
