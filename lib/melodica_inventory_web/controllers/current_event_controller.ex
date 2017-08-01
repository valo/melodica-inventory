defmodule MelodicaInventoryWeb.CurrentEventController do
  use MelodicaInventoryWeb, :controller

  def create(conn, %{"current_event_id" => event_id}) do
    conn
    |> put_session(:current_event_id, event_id)
    |> redirect(external: referrer(conn))
  end

  defp referrer(conn) do
    conn
    |> get_req_header("referer")
    |> hd
  end
end
