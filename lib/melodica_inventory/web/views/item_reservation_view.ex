defmodule MelodicaInventory.Web.ItemReservationView do
  use MelodicaInventory.Web, :view

  alias MelodicaInventory.Event

  @date_format "{YYYY} {Mshort} {D}"

  def event_name(%Event{place: place, start_date: start_date, end_date: end_date}) do
    [
      place,
      " ",
      Timex.format!(start_date, @date_format),
      " - ",
      Timex.format!(end_date, @date_format),
    ]
  end
end
