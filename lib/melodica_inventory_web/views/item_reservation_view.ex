defmodule MelodicaInventoryWeb.ItemReservationView do
  use MelodicaInventoryWeb, :view

  alias MelodicaInventory.Goods.Event

  @date_format "{YYYY} {Mshort} {D}"

  def event_name(%Event{name: name, place: place, start_date: start_date}) do
    [
      name,
      " ",
      place,
      " ",
      Timex.format!(start_date, @date_format),
    ]
  end
end
