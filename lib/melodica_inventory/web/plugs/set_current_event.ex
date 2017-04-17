defmodule MelodicaInventory.Web.Plugs.SetCurrentEvent do
  import Plug.Conn
  alias MelodicaInventory.Event
  alias MelodicaInventory.Repo

  def init(default), do: default

  def call(conn, _default) do
    events = Repo.all(Event)
    case get_session(conn, :current_event_id) do
      nil ->
        conn
        |> assign(:events, events)
      current_event_id ->
        conn
        |> assign(:current_event, Repo.get!(Event, current_event_id))
        |> assign(:events, events)
    end
  end
end
