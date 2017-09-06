defmodule MelodicaInventoryWeb.ItemView do
  use MelodicaInventoryWeb, :view
  alias MelodicaInventory.Goods.Item
  alias Cloudex.Url
  import MelodicaInventoryWeb.ItemReservationView, only: [event_name: 1]
  import MelodicaInventoryWeb.EventView, only: [event_user: 1]

  def cover_urls(%Item{images: [], attachments: []}) do
    []
  end

  def cover_urls(%Item{images: [], attachments: attachments}) do
    attachments
    |> Enum.map(&{&1.url, nil})
    |> Enum.with_index
  end

  def cover_urls(%Item{images: images}) do
    Enum.map(images, fn(image)  ->
      {Url.for(image.public_id, %{width: 400, height: 300, crop: "limit"}), image.public_id}
    end)
    |> Enum.with_index
  end

  def cover_url_first_image(%Item{images: [], attachments: []}), do: nil

  def cover_url_first_image(%Item{images: [], attachments: attachments}) do
    List.first(attachments).url
  end

  def cover_url_first_image(%Item{images: images}) do
    image = List.first(images)
    Url.for(image.public_id, %{width: 400, height: 300, crop: "limit"})
  end
end
