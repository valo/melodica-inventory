defmodule MelodicaInventoryWeb.Admin.EventArchiveView do
  use MelodicaInventoryWeb, :view

  import MelodicaInventoryWeb.EventView, only: [event_user: 1, format_date: 1]
end
