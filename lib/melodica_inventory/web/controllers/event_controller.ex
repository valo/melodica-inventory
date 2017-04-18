defmodule MelodicaInventory.Web.EventController do
  use MelodicaInventory.Web, :controller
  alias MelodicaInventory.Event

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    |> Repo.preload(item_reservations: :item)

    render conn, "show.html", event: event
  end

  def index(conn, _) do
    events = Repo.all(Event)
    |> Repo.preload([:user])

    render conn, "index.html", events: events
  end
end
