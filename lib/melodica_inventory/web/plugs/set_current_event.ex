defmodule MelodicaInventory.Web.Plugs.SetCurrentEvent do
  import Plug.Conn
  alias MelodicaInventory.Event
  alias MelodicaInventory.Repo

  def init(default), do: default

  def call(conn, _default) do
    events = Repo.all(Event)

    case current_event(conn) do
      nil ->
        conn
        |> assign(:current_event, nil)
        |> assign(:events, events)
      current_event ->
        conn
        |> assign(:current_event, current_event)
        |> assign(:events, events)
    end
  end

  defp current_event_id(conn), do: get_session(conn, :current_event_id)

  defp current_event(conn) do
    case Integer.parse(current_event_id(conn)) do
      :error ->
        nil
      {event_id, ""} ->
        Repo.get(Event, event_id)
    end
  end
end
