defmodule MelodicaInventory.Web.EventController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Event

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    |> Repo.preload(item_reservations: :item)

    render conn, "show.html", event: event
  end
end
