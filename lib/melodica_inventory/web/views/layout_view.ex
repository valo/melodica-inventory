defmodule MelodicaInventory.Web.LayoutView do
  use MelodicaInventory.Web, :view
  import MelodicaInventory.Web.ItemReservationView, only: [event_name: 1]
  alias MelodicaInventory.Event

  def selected_event_attr(%Event{id: current_event_id}, %Event{id: event_id})
    when current_event_id == event_id, do: "selected"

  def selected_event_attr(_, _), do: ""
end
