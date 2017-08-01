defmodule MelodicaInventoryWeb.LayoutView do
  use MelodicaInventoryWeb, :view
  import MelodicaInventoryWeb.ItemReservationView, only: [event_name: 1]
  alias MelodicaInventory.Goods.Event

  def selected_event_attr(%Event{id: current_event_id}, %Event{id: event_id})
    when current_event_id == event_id, do: "selected"

  def selected_event_attr(_, _), do: ""
end
