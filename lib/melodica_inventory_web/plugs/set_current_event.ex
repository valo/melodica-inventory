defmodule MelodicaInventoryWeb.Plugs.SetCurrentEvent do
  @moduledoc false

  import Plug.Conn
  import Ecto.Query
  alias MelodicaInventory.Goods.Event
  alias MelodicaInventory.Repo

  def init(default), do: default

  def call(conn, _default) do
    current_events_list =
      Event
      |> where([e], is_nil(e.archived_at))
      |> order_by([e], desc: e.start_date)
      |> Repo.all()

    case current_event(conn) do
      nil ->
        conn
        |> assign(:current_event, nil)
        |> assign(:current_events_list, current_events_list)

      current_event ->
        conn
        |> assign(:current_event, current_event)
        |> assign(:current_events_list, current_events_list)
    end
  end

  defp current_event_id(conn), do: get_session(conn, :current_event_id)

  defp current_event(conn) do
    case parse_current_event_id(current_event_id(conn)) do
      :error ->
        nil

      {event_id, _} ->
        Repo.get(Event, event_id)
    end
  end

  defp parse_current_event_id(nil), do: :error
  defp parse_current_event_id(current_event_id), do: Integer.parse(current_event_id)
end
