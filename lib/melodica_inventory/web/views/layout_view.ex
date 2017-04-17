defmodule MelodicaInventory.Web.LayoutView do
  use MelodicaInventory.Web, :view
  import MelodicaInventory.Web.ItemReservationView, only: [event_name: 1]

  def selected_event_attr(current_event, event) when event == current_event, do: "selected"

  def selected_event_attr(current_event, event), do: ""
end
