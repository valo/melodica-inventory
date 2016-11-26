defmodule MelodicaInventory.TrelloLane do
  defstruct [:id, :name]

  def get_all(board_id) do
    HTTPoison.get!(get_lanes_url(board_id), %{}, [
      params: %{
        key: Application.fetch_env!(:melodica_inventory, :api_key),
        token: Application.fetch_env!(:melodica_inventory, :token)
      }
    ]) |> decode_response
  end

  defp get_lanes_url(board_id) do
    trello_url <> "/boards/" <> board_id <> "/lists"
  end

  defp decode_response(%HTTPoison.Response{body: body, status_code: 200}) do
    Poison.decode!(body, as: [%MelodicaInventory.TrelloLane{}])
  end

  defp trello_url do
    Application.fetch_env!(:melodica_inventory, :trello_url)
  end
end
